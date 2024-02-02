<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ page language="java"%>
<%@ page import="java.lang.String.*" %>
<%@ page import="java.util.zip.ZipOutputStream"%>
<%@ page import="java.util.zip.ZipEntry"%>
<%@ page import="java.io.BufferedInputStream"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.IOException"%>
<%@ page import="javax.servlet.ServletException"%>
<%@ page import="javax.servlet.ServletOutputStream"%>
<%@ page import="javax.servlet.http.HttpServletRequest"%>
<%@ page import="javax.servlet.http.HttpServletResponse"%>
<%
 /*download all files --> create zip file*/ 
 //서버의 실제 파일이 저장될 서버의 절대 경로 (파일 시스템상의 위치)
 String contextRealPath = request.getSession().getServletContext().getRealPath("/");
 
 //넥사크로플랫폼에서 전달한 폴더이름
 String folderName = request.getParameter("fileFolder");
 
 //넥사크로플랫폼에서 전달한 파일 이름 리스트
 String fileList  = request.getParameter("fileList");
 
 //","로 나열된 오브젝트를 나누어 배열로 만든다.
 String arrNameList[] = fileList.split(",");

 ServletOutputStream outStream = null;
 BufferedInputStream inStream = null;
 
 // ZipOutputStream 스트림을 생성을 통한 파일 압축
 ZipOutputStream  zoutStream = null;

 try
 {
  //파일 다운로드 Content-Type = "application/octet-stream"
  response.setContentType("application/octet-stream;charset=utf-8");
  
  //헤더 값 "attachment"과 "Content-Disposition"이 함께 설정되어있으면 브라우저에 따라 'Save As'옵션
  response.setHeader("Content-Disposition", "attachment; filename = \"" + folderName + ".zip" + "\"");
  
  out.clear();
  out = pageContext.pushBody();

  outStream = response.getOutputStream();
  zoutStream = new ZipOutputStream(outStream);
  zoutStream.setLevel(8);
  
  String fileName = "";
  String filePath = "";
  
  for( int i = 0; i < arrNameList.length; i++ ){
   fileName = new String(arrNameList[i].getBytes("iso8859-1"), "utf-8");
   filePath = contextRealPath + folderName + "\\" + fileName;
   
   File fis = new File(filePath);
   inStream = new BufferedInputStream(new FileInputStream(fis));
   
   ZipEntry zentry = new ZipEntry(fileName);
   zentry.setTime(fis.lastModified());
   zoutStream.putNextEntry(zentry);
   
   byte[] buffer = new byte[1024];
   int n = 0;
   while ((n = inStream.read(buffer, 0, 1024)) != -1)
   {
    zoutStream.write(buffer, 0, n);
   }   
   zoutStream.closeEntry();   
  }  
 }
 catch (Exception e)
 {
  e.printStackTrace();
 }
 finally
 {
  if (zoutStream != null)
  {
   try
   {
    zoutStream.close();
   }
   catch (Exception e)
   {
    e.printStackTrace();
   }
  }
  if (outStream != null)
  {
   try
   {
    outStream.close();
   }
   catch (Exception e)
   {
    e.printStackTrace();
   }
  }
  if (inStream != null)
  {
   try
   {
    inStream.close();
   }
   catch (Exception e)
   {
    e.printStackTrace();
   }
  }  
 }
%>