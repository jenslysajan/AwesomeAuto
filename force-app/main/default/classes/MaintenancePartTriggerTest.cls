@isTest
public class MaintenancePartTriggerTest {
	@isTest
    Public static void Test1(){
        Account a = new account(name = 'test');
        insert a;
        contact c = new contact(lastName = 'contact',accountId = a.id);
        insert c;
        Vehicle__c  v = new Vehicle__c (Make__c = 'Ford',
                                        Model__c = 'Fiesta', 
                                        year__c = 2020, 
                                        Color__c = 'Blue', 
                                        Contact__c = c.id,
                                        Last_Known_Odometer_Reading__c = 1000,
                                        Last_Service_Date__c =  date.today().adddays(-100));
        insert v;
        Maintenance_Request__c MR = new Maintenance_Request__c (Maintenance_Date__c = date.today(),
                                                               Odometer_Reading__c = 1200,status__c = 'Not Confirmed',
                                                               Vehicle__c = v.id);
        Insert MR;
        Part_Inventory__c Mainpart = new Part_Inventory__c (Name = 'main',
                                                           Part_Number__c = 1,
                                                           Quantity_in_Stock__c = 5);
        insert MainPart;
        Part_Inventory__c subpart1 = new Part_Inventory__c (Name = 'subpart1',
                                                           Part_Number__c = 2,
                                                           Quantity_in_Stock__c = 7,
                                                           Parent_Part__c = MainPart.id);
        insert subpart1;
        Part_Inventory__c subpart2 = new Part_Inventory__c (Name = 'subpart2',
                                                           Part_Number__c = 3,
                                                           Quantity_in_Stock__c = 8,
                                                            Parent_Part__c = MainPart.id);
        insert subpart2;
        
        Maintenance_Part__c MP = new Maintenance_Part__c(Maintenance_Request__c = MR.id,
                                                        Part_Inventory__c = Mainpart.Id,
                                                        Quantity_Utilized__c = 7);
        insert MP;
        MP.Quantity_Utilized__c = 2;
        update MP;
        
        MP.Quantity_Utilized__c = 1;
        update MP;
        
        MP.Quantity_Utilized__c = 12;
        update MP;
        
        delete MP;
        
        Mainpart.Quantity_in_Stock__c = 15;
        update Mainpart;
        
    }
}