table 50069 "Product Group Mapping"
{
    DrillDownPageID = "Product Group Mapping";
    LookupPageID = "Product Group Mapping";

    fields
    {
        field(10; "Code"; Code[20])
        {
        }
        field(20; "New Code"; Code[20])
        {
            TableRelation = "Gen. Product Posting Group";
        }
        field(30; Number; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Item" WHERE("Old Gen. Prod. Posting Group" = FIELD("Code")));
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

