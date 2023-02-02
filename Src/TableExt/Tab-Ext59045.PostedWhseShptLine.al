tableextension 50051 "TP Posted Whse. Shipment Line" extends "Posted Whse. Shipment Line"
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
            CalcFormula = lookup("Sales Line"."Unit Price" where("Document No." = field("Source No."), "Line No." = field("Source Line No.")));
        }
        field(50004; "Amount Including VAT"; Decimal)
        {
            Caption = 'Amount Including VAT';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Amount Including VAT" where("Document No." = field("Source No."), "Line No." = field("Source Line No.")));
        }
        field(50005; "Item Reference No."; Code[50])
        {
            Caption = 'Item Reference No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Reference"."Reference No." where("Reference Type" = field("Destination Type"), "Reference Type No." = field("Destination No."), "Item No." = field("Item No.")));
        }
        field(59006; "Description 3"; Text[100])
        {
            Caption = 'Description 3';
        }
    }

}
