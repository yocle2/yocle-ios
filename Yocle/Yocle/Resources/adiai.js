
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-69970938-1', 'auto');
  ga('send', 'pageview');


var ausername = "";
var auid = "";
var terms_agreed = 0;

var isMobile = {
    Android: function() {
        return /Android/i.test(navigator.userAgent);
    },
    BlackBerry: function() {
        return /BlackBerry/i.test(navigator.userAgent);
    },
    iOS: function() {
        return /iPhone|iPad|iPod/i.test(navigator.userAgent);
    },
    Windows: function() {
        return /IEMobile/i.test(navigator.userAgent);
    },
    any: function() {
        return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Windows());
    }
};

$(document).ready(function () {

    $('#popup3').click(function(event){  
	var formURL = "/invest/servlet/logout";
	
			$.ajax(
				{
					url : formURL,
					type: "POST",
					cache: false,
					data: "l=1",
					success:function(result) 
					{
						document.getElementById("logon0").style.display = "none";
						document.getElementById("logon1").style.display = "none";
						var obj = document.getElementById("become_member");
						if(obj) {
							obj.style.display = "block";
						}

						obj = document.getElementById("signIn2");
						if(obj) {
							obj.style.display = "block";
						}

					//	alert("123");
						document.getElementById("logon0").innerHTML = "";
					//	window.location.reload();
						doLogout();						
					}
				});	
	});

		$.validator.addMethod("chinesealphanumeric", function(value, element) {
				return this.optional(element) || ((value.match(/^[ a-zA-Z0-9\u4e00-\u9fa5-_]+$/)) && (value.replace(/\s/g, '').length>=1))
		}, "* Chinese，Alphabets and numbers only");	
			
						$('#resend').validate({
				onsubmit:false
				, rules: {
					uid: {
						required: true
						, email: true
					}
				}
				, messages: {
					uid: {
						required: "請輸入用戶電郵地址"
						, email: "請輸入郵件地址"
					}
				}
				, errorPlacement: function( error, element ) {
					error.insertAfter( element.parent() );
				}				
			});
		
			$('#login').validate({
				onsubmit:false
				, rules: {
					uid: {
						required: true
						, email: true
					}
					, pwd: {
						required: true
						, minlength: 6
					}
				}
				, messages: {
					uid: {
						required: "請輸入用戶"
						, email: "請輸入郵件地址"
					}
					, pwd: {
						required: "請輸入密碼"
						, minlength: "最少輸入6位密碼"
					}
				}
				, errorPlacement: function( error, element ) {
					error.insertAfter( element.parent() );
				}				
			});
			$('#registerform').validate({
				onsubmit:false
				, rules: {
					ruid: {
						required: true
						, email: true
					}
					, rpwd: {
						required: true
						, minlength: 6
						, maxlength: 20
					}
					, rname: {
						required: true
						, maxlength: 80
						, chinesealphanumeric: true
					}
					, rphone: {
						required: true
						, minlength: 8
						, maxlength: 11
						, digits: true
					}
					, rrphone: {
						required: false
						, minlength: 8
						, maxlength: 11
						, digits: true
					}
					, kaptcha: {
						required: true
						, minlength: 5
						, maxlength: 5
					}
					
				}
				, messages: {
					ruid: {
						required: "請輸入用戶"
						, email: "請輸入郵件地址"
					}
					, rpwd: {
						required: "請輸入密碼"
						, minlength: "最少輸入6位密碼"
						, maxlength: "最多輸入20位密碼"
					}
					, rname: {
						required: "請輸入名稱"
						, maxlength: "最多輸入80位名稱"
						, chinesealphanumeric: "請輸入中文、英文或數字組合"
					}
					, rphone: {
						required: "請輸入電話號碼"
						, minlength: "請輸入8或11位電話號碼"
						, maxlength: "請輸入8或11位電話號碼"
						, digits: "請輸入數字"
					}	
						, kaptcha: {
						required: "請輸入驗證碼"
						, minlength: "請輸入5位驗證碼"
						, maxlength: "請輸入5位驗證碼"
					}
				
				}
				, errorPlacement: function( error, element ) {
					error.insertAfter( element.parent() );
				}					
			});
			$("#registerb").click(function(){
						
						var validationResult = $('#registerform').valid();
					
						if ( !validationResult ) return;
			
						var uid = document.registerform.ruid.value;
						var pwd = document.registerform.rpwd.value;
						var name = document.registerform.rname.value;
						var phone = document.registerform.rphone.value;						
						var recaptcha = "";						
						
						
						var postData = $('#registerform').formSerialize();						
						var formURL = "/invest/servlet/selfregister";
						$.ajax(
						{
								url : formURL,
								type: "POST",
								data: postData,
								success:function(result) 
								{					
										var msg = "";
										if(result.indexOf("SUCCESS::")==0) {
											var rv = result.split("::");
											var name = rv[1];
										//	LoginSuccessful(name);
//											msg = "<div>歡迎 "+name+", 你已成功註冊成為會員!</div>";
											msg = "歡迎 "+name+", 你已成功註冊成為會員!";

//											if(typeof app != "undefined") app.doMapping(uid, msg);	
											doMapUser(uid, name, msg);
										//	$("#register-Form > div").replaceWith(msg);
										}
										else {
											var rv = result.split("::");
											var err = rv[1];
											document.getElementById("registererr").innerHTML = "<font color=\"red\">"+err+"</font>";
											document.getElementById("registererr").style.display = "inline";
										}
										
								},
								error: function(err) 
								{
										alert(err);
								}
						});
			});
			

			
			if(ausername!="") {
					LoginSuccessful(ausername);			
			}
		$("#footer").load("/footer.html");		

});

function log2Google(category, action, opt_label) {
	ga('send', 'event', category, action, opt_label);
}
function GoToUrl(url) {
  log2Google("File", "a_view", url);
	window.location.href = url;
};
function resize(id){
　  parent.document.getElementById(id).height=document.body.scrollHeight; 　　　
};
function newUser() {	
	$(".register a").trigger('click');	
};

 function LoginSuccessful(username) {
 /*
			document.getElementById("logon0").style.display = "block";
			document.getElementById("logon1").style.display = "block";

			document.getElementById("signIn2").style.display = "none";

			var obj = document.getElementById("become_member");
			if(obj) {
				obj.style.display = "none";
			}

			obj = document.getElementById("signIn2");
			if(obj) {
				obj.style.display = "none";
			}

			document.getElementById("logon0").innerHTML = "歡迎 "+username+"";
			var sidebar = $('[data-sidebar]');
			var button = $('[data-sidebar-button]');
			var overlay = $('[data-sidebar-overlay]');
			sidebar.css('margin-left', (sidebar.width() * -1)-10 + 'px');

			overlay.fadeTo('100', 0, function() {
				overlay.hide();
			});
*/			
};

function toLogout() {
{  
	var formURL = "/invest/servlet/logout";
	
			$.ajax(
				{
					url : formURL,
					type: "POST",
					cache: false,
					data: "l=1",
					success:function(result) 
					{
						doLogout();						
					}
				});	
	}
}

function loginbclick() {
						var validationResult = $('#login').valid();
					
						if ( !validationResult ) return;
						
						var uid = document.login.uid.value;
						var pwd = document.login.pwd.value;
											
						var postData = "uid="+uid+"&pwd="+pwd+"&uri=";
						var formURL = "/invest/servlet/login";
						$.ajax(
						{
								url : formURL,
								type: "POST",
								data: postData,
								success:function(result) 
								{
										var msg = "";
										if(result.indexOf("SUCCESS::")==0) {
											var rv = result.split("::");
											var name = rv[1];
										//	LoginSuccessful(name);	
//											msg = "<div>歡迎 "+name+", 你已經登錄成功!</div>";											
											msg = "歡迎 "+name+", 你已經登錄成功!";											
										//	$("#signIn-Form > div").replaceWith(msg);
			//								if(typeof app != "undefined") app.doMapping(uid, msg);		
											log2Google("App", "a_login", "user");			
											doMapUser(uid, name, msg);
										}
										else {
											document.getElementById("loginerr").innerHTML = "<font color=\"red\">無效的用戶或密碼</font>";
											document.getElementById("loginerr").style.display = "inline";
										}
										
								},
								error: function(err) 
								{
										alert(err);
								}
						});
			};

function showErrorApp(title, message) {
						if(isMobile.Android()) {
							if(typeof app != "undefined")	{
								app.showInfoDialog(title, message);		
								return;
							}
						}
						else if(isMobile.iOS()) {	
						  var uri="info.php?title="+encodeURI(title)+"&message="+encodeURI(message);
							window.location = "http://showinfodialog.adiai.com/"+uri;
							return;
						}								
}			
			
function openTerm() {
			if(terms_agreed==0) { // show terms
						if(isMobile.Android()) {
							if(typeof app != "undefined")	{
								app.showeuladialog();		
								return;
							}
						}
						else if(isMobile.iOS()) {	
							window.location = "http://showuseragreement.adiai.com/";
							return;
						}							
			}
}			
			
function continueregister() { // to be called by app native function after user clicks "accept" in the user agreement dialog
   terms_agreed = 1;
	 registerbclick();
}			
			
function registerbclick() {
						var validationResult = $('#registerform').valid();
					
					var validator = $( "#registerform" ).validate();
					if(!validator.element( "#rname" )) return;

						if ( !validationResult ) return;
			
						if(terms_agreed==0) {
							openTerm();
							return;
						}
						
						
						var uid = document.registerform.ruid.value;
						var pwd = document.registerform.rpwd.value;
						var name = document.registerform.rname.value;
						var phone = document.registerform.rphone.value;						
						var recaptcha = "";						
								
						var postData = $('#registerform').formSerialize();							
						var formURL = "/invest/servlet/selfregister";
						$.ajax(
						{
								url : formURL,
								type: "POST",
								data: postData,
								success:function(result) 
								{
										var msg = "";
										if(result.indexOf("SUCCESS::")==0) {
											var rv = result.split("::");
											var name = rv[1];
											log2Google("App", "a_register", "user");
										//	LoginSuccessful(name);		
											msg = "歡迎 "+name+", 你已成功註冊成為會員!";										
											doMapUser(uid, name, msg);											
										}
										else {
											var rv = result.split("::");
											var err = rv[1];
											document.getElementById("registererr").innerHTML = "<font color=\"red\">"+err+"</font>";
											document.getElementById("registererr").style.display = "inline";
											showErrorApp("註册失敗", err);
										}
										
								},
								error: function(err) 
								{
										alert(err);
								}
						});
			};

			
				function resendbclick() {
						var validationResult = $('#resend').valid();
					
						if ( !validationResult ) return;
						
						var uid = document.resend.uid.value;
											
						document.getElementById("resenderr").innerHTML = "<br><font color=\"yellow\">請稍候...</font>";
						document.getElementById("resenderr").style.display = "inline";												
																		
						var postData = "email="+uid;
						var formURL = "/invest/servlet/resendpwd";
						$.ajax(
						{
								url : formURL,
								type: "POST",
								data: postData,
								success:function(result) 
								{								
										var msg = "";
										if(result.indexOf("SUCCESS")==0) {
										  log2Google("App", "a_resendpassword", "user");
										  document.getElementById("resenderr").innerHTML = "<br><font color=\"yellow\">密碼已成功發送</font>";
											document.getElementById("resenderr").style.display = "inline";								
										}
										else {
											document.getElementById("resenderr").innerHTML = "<br><font color=\"red\">無效的電郵地址</font>";
											document.getElementById("resenderr").style.display = "inline";
										}
										
								},
								error: function(err) 
								{
										//alert(err);
								}
						});
			};
		
			
			
function getUid() { // this function is not used now
	if(isMobile.Android())  {
		if(typeof app != "undefined") app.setUid(auid);			
	}
	else if(isMobile.iOS()) {	
//		window.location = "http://setuid.adiai.com/"+auid;
		return auid;
	}	
};
function getHtmlSource(key) {
  if(typeof app != "undefined") app.setHtmlSource(key+"--adiaponglist2018--"+$('html').html().toString());				
};
function viewFile(file) {
 if(isMobile.Android()) {
		log2Google("File", "a_view", file);
		if(typeof app != "undefined") app.downloadFile(file);				
 }
 else if(isMobile.iOS()) {
    window.location = "http://downloadfile.adiai.com/"+file;
 }
};
function doLogout() { // done in app, so this function is not used now
  if(isMobile.Android())  {
		if(typeof app != "undefined") app.doLogout("dummy");				
	}
	else if(isMobile.iOS()) {
		window.location = "http://logout.adiai.com/";
	}
};
function youtube(video_id) {
  if(isMobile.Android()) {
		if(typeof app != "undefined")	{
			log2Google("File", "a_view", video_id);
			app.playyoutube(video_id);		
			return;
		}
	}
	else if(isMobile.iOS()) {
		window.location = "http://viewyoutubevideo.adiai.com/"+video_id;
		return;
	}
  else window.location = "http://www.youtube.com/embed/"+video_id; 
};
function doMapUser(uid, name, msg) {
	if(isMobile.Android())  {
		if(typeof app != "undefined") app.doMapping(uid, name, msg);
	}
	else if(isMobile.iOS()) {
		window.location = "http://login.adiai.com/"+encodeURI(uid+"<>"+msg);
	}
};
function showPage(page) {
  if(isMobile.Android()) {
		if(typeof app != "undefined")	{
		  log2Google("File", "a_view", page);
			app.showPage(page);		
			return;
		}
	}
	else if(isMobile.iOS()) {
		window.location = page;
		return;
	}
  window.location = page; 
};
function showInNewWindow(page) {
  if(isMobile.Android()) {
		if(typeof app != "undefined")	{
			log2Google("File", "a_view", page);
			app.showInNewWindow(page);		
			return;
		}
	}
	else if(isMobile.iOS()) {
		var uri = "newwindow.php?url="+encodeURI(page);
		window.location = "http://showinnewnativewindow.adiai.com/"+uri;
		return;
	}
  window.location = page; 
};

function decodeSN(s) {
 if(s==1) return "Facebook"; 
 if(s==2) return "Whatsapp"; 
 if(s==3) return "Wechat"; 
}
 
function toShare(s, i, uri) {
  if(isMobile.Android()) {
		if(typeof app != "undefined")	{
		  log2Google("Share", decodeSN(s)+"_a_share", ""+i);
			app.toShare(s, i, uri);		
			return;
		}
	}	
	else if(isMobile.iOS()) {
	  log2Google("Share", decodeSN(s)+"_a_share", ""+i);
		var uri = "share.php?socialnetwork="+s+"&itemid="+i+"&itemimageuri="+encodeURI(uri);
		window.location = "http://toshare.adiai.com/"+uri;
		return;
	}
};
function handleEvent(uri) {
	  var typeid = parseInt(uri.substring(0,1));
		uri = uri.substring(2);

		log2Google("File", "a_view", uri);
		if(typeid==2) { // document
			viewFile(uri);
		}
		else if(typeid==3) { // private video
			
		}
		else if(typeid==4) { // text
			showInNewWindow(uri.substring(1))
		}
		else if(typeid==5) { // youtube video
			youtube(uri);
		}
		else if(typeid==6) { // external url
			showInNewWindow(uri);
		}
};

