tableextension 59096 "TP Production BOM Header" extends "Production BOM Header"
{
    fields
    {
        // field(50000; "Article Release Status"; Text[30])
        // {
        //     Caption = 'Article Release Status';
        //     FieldClass = FlowField;
        //     CalcFormula = Lookup(Item."Release Status" WHERE("No." = FIELD("No.")));
        // }
        field(50001; "BOM Index"; Code[10])
        {
            Caption = 'BOM Index';
        }
        field(50002; "Pre-Calculated Unit Cost"; Decimal)
        {
            Caption = 'Pre-Calculated Unit Cost';
        }
        field(50003; "Created By Import"; Boolean)
        {
            Caption = 'Created By Import';
        }
        field(50004; "Active Version"; Code[20])
        {
            Caption = 'Active Version';
        }
        field(50005; "Rout Link Code Line"; Code[10])
        {
            Caption = 'Rout Link Code Line';
            TableRelation = "Routing Link";
        }
        field(50006; "ImportFlag"; Boolean)
        {
            Caption = 'ImportFlag';
        }
    }

}
