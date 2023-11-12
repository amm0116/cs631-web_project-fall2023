# Pages to Build

* **index (Home)**
    * "Welcome back, [username]!
    * Six categories:
        * Patient Info Portal
        * Appointment Scheduling Portal
        * In-Patient Scheduling Portal
        * Surgery Scheduling Portal
        * Staff Info Portal
        * Shift Scheduling Portal
 
* **patient (Patient Management)**
    * 'Back' button (go to index)
    * 'Add Patient' button (go to patient-add)
    * Table
        * Information comes from PATIENT table
            * *SELECT PatientNo, Fname, Lname, Ssn, Dob FROM PATIENT*
        * Each patient row displays this data...
            * Patient No
            * First name
            * Last name
            * SSN
            * DOB
        * Each patient row contains this link...
            * 'View' (go to patient-view, pass in patient no. as POST parameter)

* **patient-add (Patient Management / Add)**
    * 'Back' button (go to patient)
    * 'Add' button (perform SQL insert query and go to patient)
        * *INSERT INTO PATIENT VALUES (Fname, Minit, Lname, Ssn, Gender, Dob, BloodType, RhFactor, Pcp, Addr, City, StateProv, ZIP, Country, Phone) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)*
    * Display the following fields...
        * First Name (text, required)
        * M.I. (text)
        * Last Name (text, required) 
        * SSN (text)
        * Gender (dropdown: M, F, required)
        * DOB (date, required)
        * Blood Type (dropdown: A, B, AB, O)
        * Rh Factor (dropdown: +, -)
        * Primary Care Physician (dropdown: *SELECT EmpNo FROM STAFF WHERE EmpType = 'PHYS' AND EmpStatus = 'A'*, required)
        * Address (text)
        * City (text)
        * State/Prov (dropdown: *SELECT Code FROM STATEPROV*)
        * Country (dropdown: *SELECT Code FROM Country*)
        * Phone (text)

* **patient-view (Patient Management / View)**
    * 'Back' button (go to patient)
    * Receive in patient no. as POST parameter and immediately perform this SQL query...
        * *SELECT * FROM PATIENT WHERE PatientNo = [POST]*
    * Then display the following as read-only text...
        * Patient No.
        * First Name
        * M.I.
        * Last Name
        * SSN
        * Gender
        * DOB
        * Blood Type
        * Rh Factor
        * Primary Care Physician
        * Address
        * City
        * State/Prov
        * Country
        * Phone
    * And the following as read-only subtables...
        * Illnesses
            * Table
                * Information comes from PATIENT_ILLNESS table
                * *SELECT * FROM PATIENT_ILLNESS WHERE PatientNo = [POST]*
                * Each illness row displays this data...
                    * Patient No
                    * Illness
                    * Diagnosis Date
                    * Diagnosed By
        * Allergies
            * Table
                * Information comes from ALLERGY table
                * *SELECT * FROM ALLERGY WHERE PatientNo = [POST]*
                * Each allergy row displays this data...
                    * Patient No
                    * Allergy
                    * Diagnosis Date
                    * Diagnosed By
        * Appointments
            * 'Add' button (go to appointment-add, pass in patient no. as POST parameter)
            * Table
                * Information comes from APPOINTMENT table
                * *SELECT * FROM APPOINTMENT WHERE PatientNo = *
                * Each appointment row displays this data...
                    * Patient No
                    * Facility
                    * Physician
                    * Time
                    * Type
                    * Note
        * Inpatient Stays
            * 'Add' button (go to stay-add, pass in patient no. as POST parameter)
            * Table
                * Information comes from INPATIENT_STAY table
                * *SELECT * FROM INPATIENT_STAY WHERE PatientNo = [POST]*
                * Each stay row displays this data...
                    * Patient No
                    * Room/Bed
                    * Check In
                    * Check Out
        * Surgeries
            * 'Add' button (go to surgery-add, pass in patient no. as POST parameter)
            * Table
                * Information comes from SURGERY table
                * *SELECT * FROM SURGERY WHERE PatientNo = [POST]*
                * Each surgery row displays this data...
                    * Patient No
                    * Operation Theatre
                    * Time
                    * Type
                    * Special Needs

* **appointment (Appointments)**
    * Filter fields (can fill in as many of as few as desired)
        * Physician
        * Date
    * 'Filter' button (reload table)
        * *SELECT * FROM APPOINTMENT WHERE EmpNo = [Physician] AND Date >= [Date12:00:00AM] AND Date <= [Date11:59:59PM]*
    * 'Back' button (go to index)
    * 'Add Appointment' button (go to appointment-add)
    * Table
        * Information comes from APPOINTMENT table
            * *SELECT * FROM APPOINTMENT*
        * Each appointment row displays this data...
            * Patient No.
            * Physician
            * Facility
            * Time
            * Type
            * Note

* **appointment-add (Appointments / Add)**
    * Possible to receive in patient no. as POST parameter (and immediately initialize patient no. field as appropriate).
    * 'Back' button (go to appointment)
    * 'Add' button (perform SQL insert query and go to appointment)
        * *INSERT INTO APPOINTMENT VALUES (PatientNo, Facility, EmpNo, ApptTime, Type, Note) VALUES (?, ?, ?, ?, ?, ?)*
    * Display the following fields...
        * Patient No. (dropdown: *SELECT PatientNo FROM PATIENT*, required)
        * Physician (dropdown: *SELECT EmpNo FROM STAFF WHERE EmpType = 'PHYS' AND EmpStatus = 'A'*, required)
        * Facility (dropdown: *SELECT Code FROM FACILITY*)
        * Time (date/time)
        * Type (dropdown: Routine, Consultation, Follow-up, Diagnostic, Vaccinations, Emergency)
        * Note (text)

* **staff (Staff Management)**
    * Filter fields (can fill in as many of as few as desired)
        * Employee Type
    * 'Filter' button (reload table)
        * *SELECT * FROM APPOINTMENT WHERE EmpType = [EmployeeType]*
    * 'Back' button (go to index)
    * 'Add Staff' button (go to staff-add)
    * Table
        * Information comes from STAFF table
            * *SELECT EmpNo, Fname, Lname, EmpType, Position FROM STAFF*
        * Each staff row displays this data...
            * Employee No.
            * First name
            * Last name
            * Employee Type
            * Position
        * Each staff row contains these links...
            * 'View' (go to staff-view, pass in employee no. as POST parameter)
            * 'Delete' (go to staff-remove, pass in employee no. as POST parameter)

* **staff-add (Staff Management / Add)**
    * 'Back' button (go to staff)
    * 'Add' button (perform SQL insert query and go to staff)
        * *INSERT INTO STAFF VALUES (Fname, Minit, Lname, Ssn, Gender, EmpType, Title, EmpStatus, Addr, City, StateProv, ZIP, Country, Phone) VALUES (?, ?, ?, ?, ?, ?, ?, 'A', ?, ?, ?, ?, ?, ?)*
    * Display the following fields...
        * First Name (text, required)
        * M.I. (text)
        * Last Name (text, required) 
        * SSN (text)
        * Gender (dropdown: M, F, required)
        * Employee Type (dropdown: PHYS, NURS, SURG, SUPP, required)
        * Title
        * Address (text)
        * City (text)
        * State/Prov (dropdown: *SELECT Code FROM STATEPROV*)
        * Country (dropdown: *SELECT Code FROM Country*)
        * Phone (text)

* **staff-view (Staff Management / View)**
    * 'Back' button (go to staff)
    * Receive in staff no. as POST parameter and immediately perform this SQL query...
        * *SELECT * FROM STAFF WHERE EmpNo = [POST]*
    * Then display the following as read-only text...
        * Patient No.
        * First Name
        * M.I.
        * Last Name
        * SSN
        * Gender
        * Employee Type
        * Title
        * Employment Status
        * Address
        * City
        * State/Prov
        * Country
        * Phone

* **staff-remove (Staff Management / Remove)**
    * Receive in employe no. as POST parameter
    * 'Back' button (go to staff)
    * 'Delete' button (perform SQL delete query and go to staff)
        * *DELETE FROM STAFF WHERE EmpNo = [EmployeeNo]*
    * Display warning message that action cannot be undone.

* **shift (Shift Scheduling)**
    * 'Back' button (go to index)
    * 'Add Shift' button (go to shift-add)
    * Table
        * Information comes from SHIFT table
            * *SELECT * FROM SHIFT*
        * Each shift row displays this data...
            * Employee No.
            * Shift Start Time
            * Shift End Time

* **shift-add (Shift Scheduling / Add)**
    * 'Back' button (go to shift)
    * 'Add' button (perform SQL insert query and go to shift)
        * *INSERT INTO SHIFT VALUES (EmpNo, ShiftStart, ShiftEnd) VALUES (?, ?, ?)*
    * Display the following fields...
        * Employee No. (dropdown: *SELECT EmpNo FROM STAFF WHERE EmpStatus = 'A'*, required)
        * Shift Start Time (date/time)
        * Shift End Time (date/time)
    
* **surgery (Surgeries)**
    * Filter fields (can fill in as many of as few as desired)
        * Surgeon
        * Facility
        * Room (any way to constrain this by facility selection?)
        * Date
    * 'Filter' button (reload table)
        * *SELECT * FROM SURGERY A, SURGERY_STAFF B, STAFF C, OP_THEATRE D WHERE B.EmpNo = [Surgeon] AND A.SurgeryTime >= [Date12:00:00AM] AND A.SurgeryTime <= [Date11:59:59PM] AND A.SurgeryNo = B.SurgeryNo AND B.EmpNo = C.EmpNo AND C.EmpType = 'SURG' AND A.OpTheatre = D.Code AND D.Facility = [Facility] AND D.Room = [Room]*
    * 'Back' button (go to index)
    * 'Add Surgery' button (go to surgery-add)
    * Table
        * Information comes from SURGERY table
            * *SELECT A.SurgeryNo, A.PatientNo, A.SurgeryType, A.SpecialNeeds, B.EmpNo, D.Facility, D.Theatre FROM SURGERY A, SURGERY_STAFF B, STAFF C, OP_THEATRE D WHERE A.SurgeryNo = B.SurgeryNo AND B.EmpNo = C.EmpNo AND C.EmpType = 'SURG' AND A.OpTheatre = D.Code*
        * Each surgery row displays this data...
            * Surgery No.
            * Patient No.
            * Surgeon
            * Facility
            * Room
            * Type
            * Time
            * Special Needs

* **surgery-add (Surgeries / Add)**
    * Possible to receive in patient no. as POST parameter (and immediately initialize patient no. field as appropriate).
    * 'Back' button (go to surgery)
    * 'Add' button (perform SQL insert query and go to surgery)
        * *INSERT INTO SURGERY (PatientNo, OpTheatre, SurgeryTime, SurgeryType, SpecialNeeds) VALUES (?, ?, ?, ?, ?)*
        * *INSERT INTO SURGERY_STAFF (SurgeryNo, EmpBo) VALUES (?, ?)*
            * Surgery No. must be obtained after the first insert statement
    * Display the following fields...
        * Patient No. (dropdown: *SELECT PatientNo FROM PATIENT*, required)
        * Surgeon (dropdown: *SELECT EmpNo FROM STAFF WHERE EmpType = 'SURG' AND EmpStatus = 'A'*, required)
        * Room (dropdown: *SELECT * FROM OP_THEATRE*)
        * Time (date/time)
        * Type (dropdown: *SELECT Code FROM SURG_TYPE*)
        * SpecialNeeds (text)
    * Display the following table...
        * Information comes from OP_THEATRE table
            * *SELECT * FROM OP_THEATRE*
        * Each operating theatre displays this data...
            * Room
            * Facility
            * Theatre

* **stay (Inpatient Stays)**
    * Filter fields (can fill in as many of as few as desired)
        * Facility
        * Room (any way to constrain this by facility selection?)
        * Date
    * 'Filter' button (reload table)
        * *SELECT * FROM INPATIENT_STAY A, ROOM B WHERE A.CheckInDate <= [DATE] AND (A.CheckOutDate >= [DATE] OR A.CheckOutDate IS NULL) AND A.RoomBed = B.RoomBed AND B.Facility = [FACILITY] AND B.RoomBed = [ROOM]*
    * 'Back' button (go to index)
    * 'Add Stay' button (go to stay-add)
    * Table
        * Information comes from INPATIENT_STAY table
            * *SELECT A.PatientNo, A.RoomBed, A.CheckInDate, A.CheckOutDate, A.Physician, A.Nurse, B.Facility, B.Wing, B.NurseUnit FROM INPATIENT_STAY A, ROOM B WHERE A.RoomBed = B.RoomBed*
        * Each stay row displays this data...
            * Stay No.
            * Patient No.
            * Facility
            * Unit
            * Wing
            * Room/Bed
            * CheckIn
            * CheckOut
            * Physician
            * Nurse

* **stay-add (Inpatient Stays / Add)**
    * Possible to receive in patient no. as POST parameter (and immediately initialize patient no. field as appropriate).
    * 'Back' button (go to stay)
    * 'Add' button (perform SQL insert query and go to stay)
        * *INSERT INTO INPATIENT_STAY (PatientNo, RoomBed, CheckInDate) VALUES (?, ?, ?)*
    * Display the following fields...
        * Patient No. (dropdown: *SELECT PatientNo FROM PATIENT*, required)
        * CheckIn (date/time)
        * Room/Bed (dropdown: *SELECT RoomBed FROM ROOM*)
    * Display the following table...
        * Information comes from ROOM table
            * *SELECT * FROM ROOM WHERE RoomBed NOT IN (SELECT RoomBed FROM INPATIENT_STAY WHERE CheckOutDate > DATE('now'))*
        * Each room/bed displays this data...
            * Facility
            * Unit
            * Wing
            * Room/Bed

* **stay-checkout (Inpatient Stays / CheckOut)**
    * Receive stay no. as POST parameter
    * 'Back' button (go to stay)
    * 'CheckOut' button (perform SQL update query and go to stay)
        * *UPDATE INPATIENT_STAY SET CheckOutDate = ? WHERE StayNo = ?*
    * Display the following field...
        * CheckOut (date/time)

* stay-edit-staff (Inspatient Stays / View Staff)

* stay-assign-staff (Inpatient Stays / Assign Staff)

* stay-remove-staff (Inpatient Stays / Remove Staff)
