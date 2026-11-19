ID      Feature     Test                        Expected result                         Actual outcome

F5-01   Startup     Valid data file             Menu opens                              Menu opens successfully
	
F5-02   Startup     Missing data file           Clear error; exit                       Pops error message successfully
	
F5-03   Menu        Invalid and blank choice    Message; menu repeats                   Error message + repeated menu

F5-04   Display     Display all                 All records and headings                Correctly displays all records + headings
	
F5-05   Search      Existing ID                 One exact record                        Displays only searched record
	
F5-06   Search      Missing/blank/wrong ID      Clear error; menu returns               Displays error message
	
F5-07   Add         Valid record                Appended once                           Appends to records_all + dedicated file (based on ID entered)
	
F5-08   Add         Duplicate/invalid record    Rejected; data unchanged                Rejects, doesn't make a change, displays error message
	
F5-09   Update      Valid replacement           One intended change                     Only makes change to that record in main and sub files
	
F5-10   Update      Missing/invalid input       Rejected; data unchanged                Successfully reject and not change anything
	
F5-11   Delete      Cancel                      Record remains                          Record stays intact, no change made, tmp file deleted
	
F5-12   Delete      Confirm                     Only selected record removed            Only removes selected record from main + sub files
	
F5-13   Report      Generate manual report      Named non-empty report                  Creates single, named report with all information included
	
FS-14   Report      Generate auto report        Named non-empty report                  Creates single, named report with all information included with cron job
 
F5-15   Report      Verify sections             Metadata, count, summaries, exception   All sections correctly inserted
	
F5-16   Backup      Create and inspect          Timestamped readable archive            Succesful manual compressed backup with all necessary files

F5-17   Backup      Create and inspect          Timestamped readable archive            Succesful auto compressed backup with all necessary files with cron job

F5-18   Exit report Exit option                 Clean closure                           Clean closure with alert message

F5-19   Exit IT     Exit option                 Clean closure                           Clean closure with alert message

F5-20   Exit main   Exit option                 Clean closure                           Clean closure with alert message