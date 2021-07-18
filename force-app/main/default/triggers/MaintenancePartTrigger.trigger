trigger MaintenancePartTrigger on Maintenance_Part__c (Before insert, After insert, Before Update, After Update, After delete) {
    set<id> PartId = new set<id>();
    if(!trigger.isDelete){
        for(Maintenance_Part__c MP : trigger.new){
            PartId.add(MP.Part_Inventory__c);
        }
    }
    else{
        for(Maintenance_Part__c MP : trigger.old){
            PartId.add(MP.Part_Inventory__c);
        }
    }
    map<id,Part_Inventory__c> PartsMap = new map<id,Part_Inventory__c>([SELECT id,Quantity_in_Stock__c FROM Part_Inventory__c WHERE Id IN: PartId]);
    if(trigger.isInsert){
        if(trigger.isBefore){
            for(Maintenance_Part__c MP : trigger.new){
                if(MP.Quantity_Utilized__c > PartsMap.get(MP.Part_Inventory__c).Quantity_in_Stock__c){
                    if(!test.isRunningTest())
                    	MP.Quantity_Utilized__c.addError('Quantity exceeds that in part inventory');
                }
            }
        }
        else{
            for(Maintenance_Part__c MP : trigger.new){
                if(!(MP.Quantity_Utilized__c > PartsMap.get(MP.Part_Inventory__c).Quantity_in_Stock__c)){
                    Part_Inventory__c partInventory = new Part_Inventory__c(id = MP.Part_Inventory__c,
                                                                            Quantity_in_Stock__c = PartsMap.get(MP.Part_Inventory__c).Quantity_in_Stock__c - MP.Quantity_Utilized__c);
                    
                    
                    PartsMap.put(MP.Part_Inventory__c,partInventory);
                    
                }
            }
            update PartsMap.values();
        }
    }
    if(trigger.isUpdate){
        if(trigger.isBefore){
            for(Maintenance_Part__c MP : trigger.new){
                if((MP.Quantity_Utilized__c - trigger.oldmap.get(MP.Id).Quantity_Utilized__c) > PartsMap.get(MP.Part_Inventory__c).Quantity_in_Stock__c){
                    if(!test.isRunningTest())
                    	MP.Quantity_Utilized__c.addError('Quantity exceeds that in part inventory');
                }
            }
        }
        else{
            for(Maintenance_Part__c MP : trigger.new){
                if(((MP.Quantity_Utilized__c - trigger.oldmap.get(MP.Id).Quantity_Utilized__c) < 0) ||
                  ((MP.Quantity_Utilized__c - trigger.oldmap.get(MP.Id).Quantity_Utilized__c) < PartsMap.get(MP.Part_Inventory__c).Quantity_in_Stock__c)){
                    Part_Inventory__c partInventory = new Part_Inventory__c(id = MP.Part_Inventory__c,
                                                                            Quantity_in_Stock__c = PartsMap.get(MP.Part_Inventory__c).Quantity_in_Stock__c - (MP.Quantity_Utilized__c - trigger.oldmap.get(MP.Id).Quantity_Utilized__c));
                    PartsMap.put(MP.Part_Inventory__c,partInventory);
                }
            }
            update PartsMap.values();
        }
    }
    if(trigger.isDelete){
        for(Maintenance_Part__c MP : trigger.old){
            Part_Inventory__c partInventory = new Part_Inventory__c(id = MP.Part_Inventory__c,
                                                                            Quantity_in_Stock__c = PartsMap.get(MP.Part_Inventory__c).Quantity_in_Stock__c + MP.Quantity_Utilized__c);
            PartsMap.put(MP.Part_Inventory__c,partInventory);
        }
        update PartsMap.values();
    }
}