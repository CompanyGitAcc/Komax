tableextension 59047 "TP Posted Whse. Receipt Line" extends "Posted Whse. Receipt Line"
{
    fields
    {

        field(50001; "Location Name"; text[100])
        {
            Caption = 'Location Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
        }

        field(50003; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line"."Direct Unit Cost" where("Document No." = field("Source No."), "Line No." = field("Source Line No.")));
        }
        field(50004; "Amount Including VAT"; Decimal)
        {
            Caption = 'Amount Including VAT';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line"."Amount Including VAT" where("Document No." = field("Source No."), "Line No." = field("Source Line No.")));
        }

    }

}
