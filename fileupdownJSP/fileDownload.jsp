<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ page language="java"%>
<%@ page import="java.io.BufferedInputStream"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.IOException"%>
<%@ page import="javax.servlet.ServletException"%>
<%@ page import="javax.servlet.ServletOutputStream"%>
<%@ page import="javax.servlet.http.HttpServletRequest"%>
<%@ page import="javax.servlet.http.HttpServletResponse"%>
<%
 /*download single file*/ 
 //서버의 실제 파일이 저장될 서버의 절대 경로 (파일 시스템상의 위치)
 String contextRealPath = request.getSession().getServletContext().getRealPath("/");
 
 //넥사크로플랫폼에서 전달한 파일이름
 String fileNameOrg = request.getParameter("fileName");
 
 //넥사크로플랫폼에서 전달한 폴더이름
 String folderName = request.getParameter("fileFolder");

 String fileName = new String(fileNameOrg.getBytes("iso8859-1"), "utf-8");
 String filePath = contextRealPath + folderName + "\\" + fileName;
 
 byte[] buffer = new byte[1024];

 ServletOutputStream outStream = null;
 BufferedInputStream inStream = null;

 File fis = new File(filePath);

 if(fis.exists())
 {
  try
  {
   //파일 다운로드 Content-Type = "application/octet-stream"
   response.setContentType("application/octet-stream;charset=utf-8");
   
   //헤더 값 "attachment"과 "Content-Disposition"이 함께 설정되어있으면 브라우저에 따라 'Save As'옵션
   response.setHeader("Content-Disposition", "attachment; filename = \"" + fileName + "\"");

   out.clear();
   out = pageContext.pushBody();

   outStream = response.getOutputStream();
   inStream = new BufferedInputStream(new FileInputStream(fis));

   int n = 0;
   while ((n = inStream.read(buffer, 0, 1024)) != -1)
   {
    outStream.write(buffer, 0, n);
   }
  }
  catch (Exception e)
  {
   e.printStackTrace();
  }
  finally
  {
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
  }
 }
 else
 {
  response.sendRedirect("unknownfile");
 }
%>