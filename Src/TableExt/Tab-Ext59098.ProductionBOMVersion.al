tableextension 59098 "TP Production BOM Version" extends "Production BOM Version"
{
    fields
    {
        field(50000; "Created By Import"; Boolean)
        {
            Caption = 'Created By Import';
        }
        field(50001; "Machine No."; Text[30])
        {
            Caption = 'Machine No.';
        }
        field(50002; "Select To Copy"; Boolean)
        {
            Caption = 'Select To Copy';
        }

    }

}
