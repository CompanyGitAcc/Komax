tableextension 59097 "TP Production BOM Line" extends "Production BOM Line"
{
    fields
    {
        field(50000; "Certify"; Boolean)
        {
            Caption = 'Certify';
        }
        field(50001; "Rout Link"; Code[10])
        {
            Caption = 'Rout Link';
            TableRelation = "Routing Link";
        }
        field(50002; "Quantity Used"; Decimal)
        {
            Caption = 'Quantity Used';
        }
        field(50003; "Sorce Line No."; Integer)
        {
            Caption = 'Sorce Line No.';
        }
        field(50004; "Sorce No."; Code[20])
        {
            Caption = 'Sorce No.';
        }
        field(50005; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(50006; "ImportFlag"; Boolean)
        {
            Caption = 'ImportFlag';
        }
        field(50007; "Production Lead Time"; DateFormula)
        {
            Caption = 'Production Lead Time';
        }
        field(50091; "Exist Item"; Boolean)
        {
            Caption = 'Exist Item';
            FieldClass = FlowField;
            CalcFormula = exist(Item where("No." = field("No.")));
        }
    }

}
