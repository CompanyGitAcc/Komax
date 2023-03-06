table 50030 "Inventory Group Mapping"
{
    DrillDownPageID = "Inventory Group Mapping";
    LookupPageID = "Inventory Group Mapping";

    fields
    {
        field(10; "Code"; Code[20])
        {
        }
        field(20; "New Code"; Code[20])
        {
            TableRelation = "Inventory Posting Group";
        }
        field(30; Number; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Item" WHERE("Old Inventory Posting Group" = FIELD("Code")));
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

