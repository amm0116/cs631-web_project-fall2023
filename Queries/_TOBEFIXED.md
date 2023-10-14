Foreign key(s) on the following tables don't have on update/on delete actions specified:
* STATEPROV
* PATIENT
* PATIENT_SUGAR
* NDC

Foreign key constraints need to be set up for the following tables/columns:
* PATIENT (Pcp, InsProvider)

The following tables have no sample data inserted yet:
* PATIENT_SUGAR
* NDC

The following tables may need to be split up into multiple:
* NDC