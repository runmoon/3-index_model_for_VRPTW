/*********************************************
 * OPL 12.6.1.0 Model
 * Author: Lu honghao
 * Creation Date: 2020-5-9 at ����7:43:08
 *********************************************/
 

int numOfVehicle = ...;  //���ĸ���
int numOfCustomer = ...;  //�ͻ��ĸ���
int numOfdepot = ...;  //�ͻ��ĸ���

range vehicle = 1..numOfVehicle;
range vertex = 0..numOfCustomer;
range customer = 1..numOfCustomer;

float M = ...;

float Capicity = ...; //��������
float ServiceTime = ...; //����ʱ��

//�ͻ�����
float Demand[customer] = ...;
//�ͻ�ʱ�䴰
float timeWindows[customer][1..2] = ...;  
//�ͻ�����Ͳֿ�����
float Coordinate[vertex][1..2] = ...;

//·�����룬����ʱ��
float travelTime[i in vertex][j in vertex] = ((Coordinate[i][1]-Coordinate[j][1])^2 + (Coordinate[i][2]-Coordinate[j][2])^2)^0.5;

// ����
dvar int+ x[vehicle][vertex][vertex];
dvar float+ reachTime[vertex][vehicle];

//��С���ܴ��ۣ���ʱ��/�ܾ��룩
minimize sum(k in vehicle)(
 			sum(i in vertex)(
 			sum(j in vertex) travelTime[i][j]*x[k][i][j]));	

subject to{
//   	sum(k in vehicle)sum(j in vertex)
//   	    x[0][j][k]<=  ;	

	// �˿�ֻ������1�Σ��ɹ˿�i�����ĳ���Ϊ1
 	forall(i in customer)sum(k in vehicle)sum(j in vertex) 
 		x[k][i][j]==1;
 	// ÿ��������������
 	forall(k in vehicle)(sum(i in customer)sum(j in vertex) 
 		Demand[i]*x[k][i][j]) <= Capicity;
 	// ������ӵ�0(���ֿ�)��ʼ����
	forall(k in vehicle)( sum(j in vertex) x[k][0][j] )==1;
	// ������h�������h���뿪����Լ��
	forall(k in vehicle)forall(h in vertex)
		(sum(i in vertex)x[k][i][h]-sum(j in vertex)x[k][h][j]) == 0;
	// �����뷵�زֿ�
	forall(k in vehicle)sum(i in vertex) x[k][i][0] == 1;
	// ���뿪һ���˿͵���һ���˿�֮��·;��ʱ������
	forall(k in vehicle)forall(i in customer)forall(j in vertex)
		reachTime[i][k] + travelTime[i][j] + ServiceTime - M*(1-x[k][i][j]) <= reachTime[j][k]; 
	// ���ĵ���ʱ��λ��ʱ�䴰�ڣ��������ڹ˿͵�ʱ�䴰�ڶԹ˿ͽ��з���
	forall(k in vehicle)forall(i in customer)
	  	timeWindows[i][1] <= reachTime[i][k];
	forall(k in vehicle)forall(i in customer)
	  	reachTime[i][k] <= timeWindows[i][2];
 }