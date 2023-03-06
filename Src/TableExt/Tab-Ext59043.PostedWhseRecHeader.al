tableextension 50043 "TP Posted Whse. Receipt Header" extends "Posted Whse. Receipt Header"
{
    fields
    {
        field(50000; "Buy-from Type"; Option)
        {
            Caption = 'Buy-from Type';
            OptionCaption = 'Customer,Vendor,Company';
            OptionMembers = "Customer","Vendor","Company";
        }
        field(50001; "Buy-from No."; Code[20])
        {
            Caption = 'Buy-from No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Buy-from Type" = CONST("Customer")) Customer
            ELSE
            IF ("Buy-from Type" = CONST("Vendor")) Vendor
            ELSE
            IF ("Buy-from Type" = CONST("Company")) Location;
        }
        field(50002; "Buy-from Address Code"; Code[20])
        {
            Caption = 'Buy-from Address Code';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Buy-from Type" = CONST("Customer")) "Ship-to Address".Code where("Customer No." = field("Buy-from No.")) ELSE
            IF ("Buy-from Type" = CONST("Vendor")) "Order Address".Code where("Vendor No." = field("Buy-from No."));
        }

        field(50003; "Buy-from Address"; Text[100])
        {
            Editable = true;
            Caption = 'Buy-from Address';
        }

        field(50004; "Buy-from Name"; Text[100])
        {
            Editable = true;
            Caption = 'Buy-from Name';
        }
        field(50005; "Buy-from Phone No."; Text[100])
        {
            Editable = true;
            Caption = 'Buy-from Phone No.';
        }
        field(50006; "Buy-from Contact"; Text[100])
        {
            Editable = true;
            Caption = 'Buy-from Contact';
        }

        field(50008; "Location Name"; text[100])
        {
            Caption = 'Location Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
        }

    }

}
