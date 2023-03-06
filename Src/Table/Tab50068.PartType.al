table 50028 "Part Type"
{
    DrillDownPageID = "Part Types";
    LookupPageID = "Part Types";

    fields
    {
        field(10; "Code"; Code[20])
        {
        }
        field(20; Description; Text[50])
        {
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

