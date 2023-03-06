tableextension 50048 "TP Warehouse Shipment Line" extends "Warehouse Shipment Line"
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
        field(50006; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(50007; "Customer Name"; Text[50])
        {
            Caption = 'Customer Name';
        }
        field(59030; "Description 3"; Text[100])
        {
            Caption = 'Description 3';
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
            begin
                if Item.get(Rec."No.") then begin
                    "Description 3" := Item."Description 3";
                end;
            end;
        }
    }

}
