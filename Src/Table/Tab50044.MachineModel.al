table 50024 "Machine Model"
{
    DrillDownPageID = "Machine Model";
    LookupPageID = "Machine Model";

    fields
    {
        field(1; "Code"; Code[30])
        {
        }
        field(2; Name; Text[50])
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

