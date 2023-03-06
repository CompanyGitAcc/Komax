tableextension 59036 "TP Purchase Receipt Line" extends "Purch. Rcpt. Line"
{
    fields
    {

        field(50002; "Location Name"; text[100])
        {
            Caption = 'Location Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
        }
        field(59003; "Buy-from Vendor Name"; Text[100])
        {
            Caption = 'Buy-from Vendor Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Header"."Buy-from Vendor Name" where("No." = field("Document No.")));
        }
        field(59004; "Unit of Measure Short Desc."; Code[20])
        {
            Caption = 'Unit of Measure Short Desc.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Unit of Measure"."Short Description" WHERE(Code = FIELD("Unit of Measure Code")));
        }
        field(59005; "Shelf No."; Code[20])
        {
            Caption = 'Shelf No.';
            // FieldClass = FlowField;
            // CalcFormula = "Shelf No."."Shelf No." WHERE("Item No." = FIELD("No."));
        }
        field(59006; "Posted Invoice No."; Code[20])
        {
            Caption = 'Posted Invoice No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Inv. Line"."Document No." where("Receipt No." = field("Document No.")));
            Editable = false;
        }

        field(59007; "Vendor Invoice No."; Code[100])
        {
            Caption = 'Vendor Invoice No.';
        }
        field(59008; "PO Qty."; Decimal)
        {
            Caption = 'PO Qty.';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line".Quantity where("Document No." = field("Order No.")));
        }

    }

}
