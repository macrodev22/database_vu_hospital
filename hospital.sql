CREATE DATABASE IF NOT EXISTS victoria_university_hospital;
USE victoria_university_hospital;

CREATE TABLE patient_data (
 Patient_ID INT AUTO_INCREMENT PRIMARY KEY,
 First_Name VARCHAR(50),
 Last_Name VARCHAR(50),
 Date_of_Birth DATE,
 Gender VARCHAR(10),
 Phone_Number VARCHAR(15),
 Next_of_Kin VARCHAR(100),
 Location_ID INT,
 Date_Added DATE,
 Update_Date DATE,
 FOREIGN KEY (Location_ID) REFERENCES geographical_location(Location_ID)
);

CREATE TABLE geographical_location (
 Location_ID INT AUTO_INCREMENT PRIMARY KEY,
 Village VARCHAR(100),
 Parish VARCHAR(100),
 Sub_County VARCHAR(100),
 County VARCHAR(100),
 Region VARCHAR(50),
 Population INT,
 Coordinates VARCHAR(100),
 Malaria_Risk_Level VARCHAR(50),
 Health_Facilities_Count INT,
 ITN_Coverage DECIMAL(5,2),
 Reported_Cases INT
);

CREATE TABLE facility_type (
 Facility_Type_ID INT AUTO_INCREMENT PRIMARY KEY,
 Name VARCHAR(50),
 Description TEXT,
 Date_Added DATE,
 Date_Updated DATE
);

CREATE TABLE health_facility (
 Facility_ID INT AUTO_INCREMENT PRIMARY KEY,
 Location_ID INT,
 Facility_Type INT,
 Capacity INT,
 Contact_Details VARCHAR(100),
 Date_Added DATE,
 Facility_Head VARCHAR(100),
 FOREIGN KEY(Location_ID) REFERENCES geographical_location(Location_ID),
 FOREIGN KEY(Facility_Type) REFERENCES facility_type(Facility_Type_ID)
);

CREATE TABLE user (
 User_ID INT AUTO_INCREMENT PRIMARY KEY,
 First_Name VARCHAR(50),
 Last_Name VARCHAR(50),
 Preferred_Name VARCHAR(50),
 Role_ID INT,
 Username VARCHAR(50),
 Password VARCHAR(100),
 Facility_ID INT,
 FOREIGN KEY (Role_ID) REFERENCES user_role(Role_ID),
 FOREIGN KEY (Facility_ID) REFERENCES health_facility(Facility_ID)
);

CREATE TABLE user_role (
 Role_ID INT AUTO_INCREMENT PRIMARY KEY,
 Role_Name VARCHAR(50),
 Role_Description TEXT,
 Date_Added DATE,
 Updated_Date DATE
);

CREATE TABLE resource (
 Resource_ID INT AUTO_INCREMENT PRIMARY KEY,
 Facility_ID INT,
 Resource_Type VARCHAR(50),
 Quantity INT,
 Last_Updated_Date DATE,
 Description TEXT,
 Date_Added DATE,
 Update_Date DATE,
 FOREIGN KEY (Facility_ID) REFERENCES health_facility(Facility_ID)
);

CREATE TABLE malaria_type (
 Type_ID INT AUTO_INCREMENT PRIMARY KEY,
 Type_Name VARCHAR(50),
 Description TEXT,
 Date_Added DATE,
 Added_By INT,
 Update_Date DATE,
 FOREIGN KEY (Added_By) REFERENCES user(User_ID)
);

CREATE TABLE treatment (
 Treatment_ID INT AUTO_INCREMENT PRIMARY KEY,
 Treatment_Name VARCHAR(50),
 Treatment_Description TEXT,
 Dosage VARCHAR(50),
 Side_Effects TEXT,
 Date_Added DATE,
 Update_Date DATE
);

CREATE TABLE visit_record (
 Visit_ID INT AUTO_INCREMENT PRIMARY KEY,
 Patient_ID INT,
 Visit_Number INT,
 Visit_Date DATE,
 Facility_ID INT,
 Date_Added DATE,
 Update_Date DATE,
 FOREIGN KEY (Patient_ID) REFERENCES patient_data(Patient_ID),
 FOREIGN KEY (Facility_ID) REFERENCES health_facility(Facility_ID)
);

CREATE TABLE treatment_outcome (
 Outcome_ID INT AUTO_INCREMENT PRIMARY KEY,
 Outcome_Name VARCHAR(50),
 Outcome_Description TEXT,
 Date_Added DATE,
 Added_By INT,
 Update_Date DATE,
 FOREIGN KEY (Added_By) REFERENCES user(User_ID)
);

CREATE TABLE malaria_cases(
 Case_ID INT AUTO_INCREMENT PRIMARY KEY,
 Patient_ID INT,
 Facility_ID INT,
 Date_of_Diagnosis DATE,
 Type_of_Malaria INT,
 Treatment_ID INT,
 Outcome_ID INT,
 FOREIGN KEY (Patient_ID) REFERENCES patient_data (Patient_ID),
 FOREIGN KEY (Facility_ID) REFERENCES health_facility (Facility_ID),
 FOREIGN KEY (Type_of_Malaria) REFERENCES malaria_type (Type_ID),
 FOREIGN KEY (Treatment_ID) REFERENCES treatment (Treatment_ID),
 FOREIGN KEY (Outcome_ID) REFERENCES treatment_outcome (Outcome_ID)
);

CREATE TABLE system_log(
 Log_ID INT AUTO_INCREMENT PRIMARY KEY,
 User_ID INT,
 Activity TEXT,
 Timestamp DATETIME,
 IP_Address VARCHAR(100),
 Location VARCHAR(100),
 FOREIGN KEY (User_ID) REFERENCES user(User_ID)
);

CREATE TABLE interventions (
 Intervention_ID INT AUTO_INCREMENT PRIMARY KEY,
 Type VARCHAR(50),
 Location_ID INT,
 Start_Date DATE,
 End_Date DATE, 
 Outcome VARCHAR(50),
 Date_Added DATE,
 Update_Date DATE,
 FOREIGN KEY (Location_ID) REFERENCES geographical_location(Location_ID)
);

CREATE TABLE referral (
 Referral_ID INT AUTO_INCREMENT PRIMARY KEY,
 Case_ID INT,
 Referred_From INT,
 Referred_To INT,
 Referral_Date DATE,
 Reason TEXT,
 Outcome_ID INT,
 Update_Date DATE,
 Referred_By INT,
 FOREIGN KEY (Case_ID) REFERENCES malaria_cases(Case_ID),
 FOREIGN KEY (Referred_From) REFERENCES health_facility(Facility_ID),
 FOREIGN KEY (Referred_To) REFERENCES health_facility(Facility_ID),
 FOREIGN KEY (Outcome_ID) REFERENCES treatment_outcome(Outcome_ID),
 FOREIGN KEY (Referred_By) REFERENCES user(User_ID)
);

CREATE TABLE laboratory_test (
 Test_ID INT AUTO_INCREMENT PRIMARY KEY,
 Case_ID INT,
 Test_Type VARCHAR(50),
 Test_Result VARCHAR(50),
 Test_Date DATE,
 Technician_ID INT,
 FOREIGN KEY (Case_ID) REFERENCES malaria_cases (Case_ID),
 FOREIGN KEY (Technician_ID) REFERENCES user(User_ID)
);

CREATE TABLE epodemiological_data (
 Data_ID INT AUTO_INCREMENT PRIMARY KEY,
 Location_ID INT,
 Recorded_Date DATE,
 Cases_Per_Thousand_People INT,
 Rainfall INT,
 Average_Temperature DECIMAL(5,2),
 Update_Date DATE,
 Added_By INT,
 FOREIGN KEY (Location_ID) REFERENCES geographical_location (Location_ID),
 FOREIGN KEY (Added_By) REFERENCES user(User_ID)
);

CREATE TABLE supply_chain(
 Supply_ID INT AUTO_INCREMENT PRIMARY KEY,
 Resource_ID INT,
 Facility_ID INT,
 Quantity_Shipped INT,
 Shipment_Date DATE,
 Expected_Arrival_Date DATE,
 Shipped_By INT,
 Status VARCHAR(50),
 Update_Date DATE,
 FOREIGN KEY (Resource_ID) REFERENCES resource(Resource_ID),
 FOREIGN KEY (Facility_ID) REFERENCES health_facility(Facility_ID),
 FOREIGN KEY (Shipped_By) REFERENCES user(User_ID)
);

CREATE TABLE training (
 Training_ID INT AUTO_INCREMENT PRIMARY KEY,
 User_ID INT,
 Training_Type VARCHAR(100),
 Training_Date DATE,
 Completion_Status VARCHAR(50),
 FOREIGN KEY (User_ID) REFERENCES user(User_ID)
);