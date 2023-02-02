tableextension 59041 "TP Posted Whse. Shpt. Header" extends "Posted Whse. Shipment Header"
{
    fields
    {
        // field(50000; "Ship-to Type"; Option)
        // {
        //     Caption = 'Ship-to Type';
        //     OptionCaption = 'Customer,Vendor,Company';
        //     OptionMembers = "Customer","Vendor","Company";
        // }
        // field(50001; "Ship-to No."; Code[20])
        // {
        //     Caption = 'Ship-to No.';
        //     DataClassification = ToBeClassified;
        //     TableRelation = IF ("Ship-to Type" = CONST("Customer")) Customer
        //     ELSE
        //     IF ("Ship-to Type" = CONST("Vendor")) Vendor
        //     ELSE
        //     IF ("Ship-to Type" = CONST("Company")) Location;
        // }
        // field(50002; "Ship-to Address Code"; Code[20])
        // {
        //     Caption = 'Ship-to Address Code';
        //     DataClassification = ToBeClassified;
        //     TableRelation = IF ("Ship-to Type" = CONST("Customer")) "Ship-to Address".Code where("Customer No." = field("Ship-to No.")) ELSE
        //     IF ("Ship-to Type" = CONST("Vendor")) "Order Address".Code where("Vendor No." = field("Ship-to No."));
        // }
        // field(50003; "Ship-to Address"; Text[100])
        // {
        //     Editable = true;
        //     Caption = 'Ship-to Address';
        // }
        // field(50004; "Ship-to Name"; Text[100])
        // {
        //     Editable = true;
        //     Caption = 'Ship-to Name';
        // }
        // field(50005; "Ship-to Phone No."; Text[100])
        // {
        //     Editable = true;
        //     Caption = 'Ship-to Phone No.';
        // }
        // field(50006; "Ship-to Contact"; Text[100])
        // {
        //     Editable = true;
        //     Caption = 'Ship-to Contact';
        // }

        // field(50010; "Location Name"; text[100])
        // {
        //     Caption = 'Location Name';
        //     FieldClass = FlowField;
        //     CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
        // }
        field(50009; Remark; text[60])
        {
            Caption = 'Remark';
        }

    }

}
