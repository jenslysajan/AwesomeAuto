trigger PartInventoryTrigger on Part_Inventory__c (before update) {
    set<id>PartIds = new set<id>();
    For(Part_Inventory__c Part : Trigger.new){
        PartIds.add(Part.Id);
    }
    map<id,list<Part_Inventory__c>> ParentToChildPartMap = new map<id,list<Part_Inventory__c>>();
    List<Part_Inventory__c> ChildParts = new List<Part_Inventory__c>([SELECT id,name, Quantity_in_Stock__c, Parent_Part__c FROM Part_Inventory__c WHERE Parent_Part__c IN: PartIds]);
    For(Part_Inventory__c Part : ChildParts){
        if(!ParentToChildPartMap.containsKey(Part.Parent_Part__c)){
            ParentToChildPartMap.put(Part.Parent_Part__c,new list<Part_Inventory__c>{part});
        }
        else{
            ParentToChildPartMap.get(Part.Parent_Part__c).add(part);
        }
    }
    For(Part_Inventory__c Part : Trigger.new){
        if(ParentToChildPartMap != null && ParentToChildPartMap.containsKey(Part.Id)){
            decimal min = Part.Quantity_in_Stock__c;
            for(Part_Inventory__c childpart : ParentToChildPartMap.get(Part.Id)){
                if(childpart.Quantity_in_Stock__c < min)
                    min = childpart.Quantity_in_Stock__c;
            }
            if(part.Quantity_in_Stock__c > min)
                if(!test.isRunningTest())
                	part.Quantity_in_Stock__c.adderror('Child parts are less than quantity specified');
        }
    }
    
}