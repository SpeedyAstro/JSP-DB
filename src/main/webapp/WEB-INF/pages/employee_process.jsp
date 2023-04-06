<%@ page language="java" import='java.sql.*'%>
<%!
Connection connection = null;
PreparedStatement statement1 = null;
PreparedStatement statement2 = null;
	public void jspInit(){
		System.out.println("Bootstrapping the environment....");
		ServletConfig config = getServletConfig();
		String url = config.getInitParameter("jdbcUrl");
		String user = config.getInitParameter("user");
		String password = config.getInitParameter("password");
		try{
			Class.forName("com.mysql.cj.jdbc.Driver");
			connection = DriverManager.getConnection(url,user,password);
			statement1 = connection.prepareStatement("insert into employee1(ename,eaddr,esalary) values (?,?,?)");
			statement2 = connection.prepareStatement("select id,ename,eaddr,esalary from employee1");
		}catch(ClassNotFoundException e){
			e.printStackTrace();
		}catch(SQLException se){
			se.printStackTrace();
		}
}
%>
<%
	String action = request.getParameter("formreq");
	if(action.equalsIgnoreCase("register")){
		String name = request.getParameter("ename");
		String eaddr = request.getParameter("eaddr");
		String esalary = request.getParameter("esalary");
		statement1.setString(1, name);
		statement1.setString(2,eaddr);
		statement1.setInt(3,Integer.parseInt(esalary));
		int rowcount = statement1.executeUpdate();
		if(rowcount==1){
%>
	<h1 style='color:green;text-align:center;'>Employee Registered Successfully</h1>
<%
	} else {
%>
	<h1 style='color: red; text-align: center;'>Employee not registered</h1>
<%
}
%>
			
<%
	}else{
		// get the data from database 
		ResultSet resultset = statement2.executeQuery();
%>
<table bgcolor='pink' align='center' border='1'>
	<tr>
		<th>EID</th>
		<th>ENAME</th>
		<th>EADDR</th>
		<th>ESAL</th>
	</tr>

	<%
	while (resultset.next()) {
	%>
	<tr>
		<td><%=resultset.getInt(1)%></td>
		<td><%=resultset.getString(2)%></td>
		<td><%=resultset.getString(3)%></td>
		<td><%=resultset.getInt(4)%></td>
	</tr>
	<%
	}
	%>
</table>
<%
}
%>
<br />
<br />
<h1 style='text-align:center;'><a href='./index.html'>|HOMEPAGE|</a></h1>

<%!
public void jspDestroy(){
	System.out.println("Cleaning the environment....");
	try {
		if (statement1 != null)
			statement1.close();

	} catch (SQLException se) {
		se.printStackTrace();
	}
	try {
		if (statement2 != null)
			statement2.close();

	} catch (SQLException se) {
		se.printStackTrace();
	}
	try {
		if (connection != null)
			connection.close();

	} catch (SQLException se) {
		se.printStackTrace();
	}
}
%>