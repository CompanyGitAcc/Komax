table 50073 "Way Of Dispatch"
{
    DrillDownPageID = "Way Of Dispatch";
    LookupPageID = "Way Of Dispatch";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
        }
        field(2; "Dispatch Time"; DateFormula)
        {
            Caption = 'Dispatch Time';
        }
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }


    fieldgroups
    {
        fieldgroup(DropDown; Code, "Dispatch Time")
        {
        }
        fieldgroup(Brick; Code, "Dispatch Time")
        {
        }
    }
}

