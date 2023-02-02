tableextension 59109 "TP Config. Package" extends "Config. Package"
{
    fields
    {
        field(50000; "Assigned User ID"; text[35])
        {
            Caption = 'Assigned User ID';
            TableRelation = "User Setup";
        }

    }

}
