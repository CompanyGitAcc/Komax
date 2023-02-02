tableextension 59102 "TP Inventory Setup" extends "Inventory Setup"
{
    fields
    {
        field(50000; "Default Custom Location"; Code[20])
        {
            Caption = 'Default Custom Location';
            TableRelation = Location;
        }

    }

}
