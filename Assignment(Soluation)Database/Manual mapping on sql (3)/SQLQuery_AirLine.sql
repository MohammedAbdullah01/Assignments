create table aircrafts  
(
	ac_id			int primary key identity,
	ac_capacity		varchar(30) not null ,
	ac_model		varchar not null,
	ac_major_pilot	varchar(20) not null, 
	ac_assistant 	varchar(20) not null,
	ac_host_1		varchar(20) not null,
	ac_host_2		varchar(20) not null , 
	al_id			int not null,
)

create table airlines 
(
	al_id				int primary key identity,
	al_name				varchar(20) not null ,
	al_address			varchar(50) not null,
	al_contact_person	varchar(20) not null
)

create table airline_phones 
(
	al_id		int primary key,
	phone		char(14) not null ,
)

create table transactions  
(
	tr_id			int primary key identity,
	tr_description	varchar(100) not null ,
	tr_amount		smallmoney not null,
	tr_date			date not null,
	al_id			int not null
)

create table Employees 
(
	em_id		int primary key identity ,
	em_name		varchar(20) not null,
	em_address	varchar(50),
	em_gender	varchar(1) ,
	em_position	varchar(30),
	em_BD_year	char(4) not null,
	em_DB_month varchar(10) not null,
	em_DB_day	varchar(10) not null,
	al_id		int ,
)

create table Employee_Qualifications 
(
	em_id				int ,
	em_qualification	varchar(60) not null ,
)

create table Routes 
(
	ro_id				int primary key identity ,
	ro_origin			varchar(50) not null ,
	ro_destination		varchar(50) not null ,
	ro_distance			int not null ,
	ro_classification	bit ,


)

create table Aircraft_Routes 
(
	ac_id					int,
	ro_id					int  ,
	departure 				bit not null ,
	number_of_passengers	tinyint not null ,
	price					money not null , 
	arrival 				bit not null ,

)

--Add Foreign Keys
	--1

alter table Aircrafts 
add 
constraint Fk_Airline
foreign key (al_id) 
references airlines(al_id)

	--2
	
alter table airline_phones 
add 
constraint Fk_Airline_phone
foreign key (al_id) 
references airlines(al_id)

	--3
	
alter table transactions 
add 
constraint Fk_Transaction_Airline
foreign key (al_id) 
references airlines(al_id)

	--4
	
alter table Employees 
add 
constraint Fk_Employee_Airline
foreign key (al_id) 
references airlines(al_id)

	--5
	
alter table Employee_Qualifications 
add 
constraint Fk_Employee_Qualification
foreign key (em_id) 
references Employees(em_id)

	--6
	
alter table Aircraft_Routes 
add 
constraint Fk_Aircraft_Routes_ac
foreign key (ac_id) 
references Aircrafts(ac_id)


	--7
	
alter table Aircraft_Routes 
add 
constraint Fk_Aircraft_Routes_ro
foreign key (ro_id) 
references Routes(ro_id)



