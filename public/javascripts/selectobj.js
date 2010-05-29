function selectobj(id,which){
  window.opener.document.getElementById(id).value=which;
  window.close();
}