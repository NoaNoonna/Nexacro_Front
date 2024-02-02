<%@ page import = "java.io.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "javax.activation.*" %>
<%@ page import="com.nexacro17.xapi.tx.*" %>
<%@ page import="com.nexacro17.xapi.data.*" %>
<%@ page import="com.nexacro17.xapi.data.datatype.*" %>
<%
 /*upload file List (search)*/ 
 //xapi platformrequest
 PlatformRequest platformRequest = new PlatformRequest(request.getInputStream(), 
                                                                     PlatformType.CONTENT_TYPE_XML, "utf-8");
 platformRequest.receiveData();
 
 PlatformData inPD = platformRequest.getData();
 VariableList inVariableList  = inPD.getVariableList();
 
 //파일이 저장될 폴더명 (넥사크로플랫폼에서 전달) 
 String folderName = inVariableList.getString("fileFolder");
  
 //서버의 실제 파일이 저장될 서버의 절대 경로 (파일 시스템상의 위치)
 String filePath = request.getSession().getServletContext().getRealPath("/") + folderName +"/";
 
 //실제 url 주소 : filePath와 같은 위치
 String fileUrl = "http://localhost:8080/playnexacro_nana/" + folderName + "/";
 
 //파일경로 파일생성후 파일목록을 배열로 반환
 File rf = new File(filePath); 
 File[] rfiles = rf.listFiles();
 
 //file mime-type 클래스 생성
 MimetypesFileTypeMap mimeTypesMap = new MimetypesFileTypeMap(); 
 
 //dataset 생성
 DataSet ds = new DataSet("dsList");
 ds.addColumn("FILE_NAME", DataTypes.STRING, 255);
 ds.addColumn("FILE_URL", DataTypes.STRING, 255);
 ds.addColumn("FILE_SIZE", DataTypes.STRING, 255);
 ds.addColumn("FILE_TYPE", DataTypes.STRING, 255);
 
 int row;
 if(rfiles != null)
 {
  for(int i=0; i<rfiles.length; i++)
  {
   if(rfiles[i].isFile())
   {
    //file name, url, size, content-type 저장
    row = ds.newRow();
    ds.set(row, "FILE_NAME", rfiles[i].getName());
    ds.set(row, "FILE_URL", fileUrl + rfiles[i].getName());
    ds.set(row, "FILE_SIZE", rfiles[i].length());
    ds.set(row, "FILE_TYPE", mimeTypesMap.getContentType(rfiles[i]));
   }
  }
 }
 
 //platform data 생성 및 전달
 PlatformData resData = new PlatformData();
 VariableList resVarList = resData.getVariableList();
 
 resData.addDataSet(ds);
 resVarList.add("ErrorCode", 0);
 resVarList.add("ErrorMsg", "Success" );
  
 HttpPlatformResponse pRes = new HttpPlatformResponse(response, request);
 pRes.setContentType(PlatformType.CONTENT_TYPE_XML);
 pRes.setCharset("UTF-8");
 pRes.setData(resData);
 pRes.sendData();
%>