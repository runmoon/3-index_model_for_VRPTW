/*********************************************
 * OPL 12.6.1.0 Model
 * Author: Lu honghao
 * Creation Date: 2020-5-9 at 上午7:43:08
 *********************************************/
 

int numOfVehicle = ...;  //车的个数
int numOfCustomer = ...;  //客户的个数
int numOfdepot = ...;  //客户的个数

range vehicle = 1..numOfVehicle;
range vertex = 0..numOfCustomer;
range customer = 1..numOfCustomer;

float M = ...;

float Capicity = ...; //车的容量
float ServiceTime = ...; //服务时间

//客户需求
float Demand[customer] = ...;
//客户时间窗
float timeWindows[customer][1..2] = ...;  
//客户坐标和仓库坐标
float Coordinate[vertex][1..2] = ...;

//路径距离，等于时间
float travelTime[i in vertex][j in vertex] = ((Coordinate[i][1]-Coordinate[j][1])^2 + (Coordinate[i][2]-Coordinate[j][2])^2)^0.5;

// 变量
dvar int+ x[vehicle][vertex][vertex];
dvar float+ reachTime[vertex][vehicle];

//最小化总代价（总时间/总距离）
minimize sum(k in vehicle)(
 			sum(i in vertex)(
 			sum(j in vertex) travelTime[i][j]*x[k][i][j]));	

subject to{
//   	sum(k in vehicle)sum(j in vertex)
//   	    x[0][j][k]<=  ;	

	// 顾客只被访问1次，由顾客i出发的车次为1
 	forall(i in customer)sum(k in vehicle)sum(j in vertex) 
 		x[k][i][j]==1;
 	// 每辆车的容量限制
 	forall(k in vehicle)(sum(i in customer)sum(j in vertex) 
 		Demand[i]*x[k][i][j]) <= Capicity;
 	// 车必须从点0(即仓库)开始出发
	forall(k in vehicle)( sum(j in vertex) x[k][0][j] )==1;
	// 车进入h点后必须从h点离开，度约束
	forall(k in vehicle)forall(h in vertex)
		(sum(i in vertex)x[k][i][h]-sum(j in vertex)x[k][h][j]) == 0;
	// 车必须返回仓库
	forall(k in vehicle)sum(i in vertex) x[k][i][0] == 1;
	// 车离开一个顾客到另一个顾客之间路途的时间消耗
	forall(k in vehicle)forall(i in customer)forall(j in vertex)
		reachTime[i][k] + travelTime[i][j] + ServiceTime - M*(1-x[k][i][j]) <= reachTime[j][k]; 
	// 车的到达时间位于时间窗内（车必须在顾客的时间窗内对顾客进行服务）
	forall(k in vehicle)forall(i in customer)
	  	timeWindows[i][1] <= reachTime[i][k];
	forall(k in vehicle)forall(i in customer)
	  	reachTime[i][k] <= timeWindows[i][2];
 }