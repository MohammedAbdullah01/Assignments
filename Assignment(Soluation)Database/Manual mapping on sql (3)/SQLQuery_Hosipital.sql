create table Patients 
(
	p_id		int primary key identity,
	p_name		varchar(30) not null ,
	p_dateBirth date not null,
	ward_id		int not null, 
	con_id		int not null
)

create table Wards 
(
	w_id		int primary key identity,
	p_name		varchar(30) not null ,
	nurse_num	int not null
)

create table Nurses 
(
	n_number	int primary key identity,
	n_name		varchar(30) not null ,
	n_address	varchar(50) not null ,
	w_id		int not null
)

create table Consultants 
(
	c_id	int primary key identity,
	c_name	varchar(30) not null ,
)

create table Patient_counsultant 
(
	c_id int ,
	p_id int 
)

create table Drugs 
(
	d_code		int primary key identity,
	d_dosage	varchar(30) not null ,
)

create table Drug_Brand 
(
	d_id int ,
	d_brand	varchar(30) not null ,

)

create table Nurse_Drug_Patient 
(
	n_num int not null,
	d_code int not null ,
	p_id	int not null ,
	date date not null ,
	time time not null , 
	dosage varchar(30) not null
)

alter table Patients 
add 
constraint Fk_Patient_Ward 
foreign key (ward_id) 
references Wards(w_id)

alter table Patients 
add 
constraint Fk_Patient_consultant 
foreign key (con_id) 
references Consultants(c_id)

alter table Wards 
add 
constraint Fk_Ward_Nurse 
foreign key (nurse_num) 
references Nurses(n_number)

alter table Nurses 
add 
constraint Fk_Nurse_Ward
foreign key (w_id) 
references Wards(w_id)

alter table Patient_counsultant 
add 
constraint Fk_counsultant 
foreign key (c_id) 
references Consultants(c_id)

alter table Patient_counsultant 
add 
constraint Fk_patient 
foreign key (p_id) 
references Patients(p_id)

alter table Drug_Brand 
add 
constraint Fk_Drug_Brand 
foreign key (d_id) 
references Drugs(d_code)

alter table Nurse_Drug_Patient 
add 
constraint Fk_nurse_number 
foreign key (n_num) 
references Nurses(n_number)

alter table Nurse_Drug_Patient 
add 
constraint Fk_drug_code 
foreign key (d_code) 
references Drugs(d_code)

alter table Nurse_Drug_Patient 
add 
constraint Fk_patient_id 
foreign key (p_id) 
references Patients(p_id)



