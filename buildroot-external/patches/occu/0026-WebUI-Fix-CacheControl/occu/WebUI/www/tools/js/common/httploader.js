/**
 * httploader.js
 **/
 
/**
 * L�dt XML- bzw Textdateien synchron.
 **/ 
HttpLoader = new function()
{
  /*####################*/
  /*# Private Elemente #*/
  /*####################*/
  
  /**
   * L�dt synchron Daten und gibt das XMLHttpRequest-Objekt zur�ck.
   **/
  var load = function(method, url, data)
  {
    var xhr = XMLHttpRequest_create();
    
    if (null !== xhr)
    {
      xhr.open(method, url, false);
      xhr.send(data);
      if ((xhr.status != 200) && (xhr.status !== 0)) { xhr = null; }
    }
    
    return xhr;
  };
 
  /*########################*/
  /*# �ffentliche Elemente #*/
  /*########################*/
  
  /**
   * L�dt einen Text synchron.
   **/
  this.getText = function(url)
  {
    var xhr = load("GET", url, null);
    
    if (null !== xhr) { return xhr.responseText; }
    else              { return ""; }
  };
  
  /**
   * L�dt ein XML-Dokument synchron.
   **/
  this.getXML = function(url)
  {
    var xhr = load("GET", url, null);
    
    if (null !== xhr) { return xhr.responseXML; }
    else              { return null; }
  };

}();
