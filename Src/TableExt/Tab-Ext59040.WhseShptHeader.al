tableextension 59040 "TP Warehouse Shipment Header" extends "Warehouse Shipment Header"
{
    fields
    {
        // field(50000; "Ship-to Type"; Option)
        // {
        //     Caption = 'Ship-to Type';
        //     OptionCaption = 'Customer,Vendor,Company';
        //     OptionMembers = "Customer","Vendor","Company";

        //     trigger OnValidate()
        //     begin
        //         Validate("Ship-to No.", '');
        //     end;
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

        //     trigger OnValidate()
        //     var
        //         Customer: Record Customer;
        //         Vendor: Record Vendor;
        //         Location: Record Location;
        //     begin
        //         if "Ship-to No." <> xRec."Ship-to No." then begin
        //             Validate("Ship-to Address Code", '');

        //             if ("Ship-to Type" = "Ship-to Type"::Customer) and (Rec."Ship-to Address Code" = '') then begin
        //                 if Customer.Get(Rec."Ship-to No.") then begin
        //                     Rec."Ship-to Name" := Customer.Name;
        //                     Rec."Ship-to Address" := Customer.Address;
        //                     Rec."Ship-to Phone No." := Customer."Phone No.";
        //                     Rec."Ship-to Contact" := Customer.Contact;
        //                     Rec.Modify();
        //                 end;
        //             end;
        //             if ("Ship-to Type" = "Ship-to Type"::Vendor) and (Rec."Ship-to Address Code" = '') then begin
        //                 if Vendor.Get(Rec."Ship-to No.") then begin
        //                     Rec."Ship-to Name" := Vendor.Name;
        //                     Rec."Ship-to Address" := Vendor.Address;
        //                     Rec."Ship-to Phone No." := Vendor."Phone No.";
        //                     Rec."Ship-to Contact" := Vendor.Contact;
        //                     Rec.Modify();
        //                 end;
        //             end;
        //             if ("Ship-to Type" = "Ship-to Type"::Company) and (Rec."Ship-to Address Code" = '') then begin
        //                 if Location.Get(Rec."Ship-to No.") then begin
        //                     Rec."Ship-to Name" := Location.Name;
        //                     Rec."Ship-to Address" := Location.Address;
        //                     Rec."Ship-to Phone No." := Location."Phone No.";
        //                     Rec."Ship-to Contact" := Location.Contact;
        //                     Rec.Modify();
        //                 end;
        //             end;
        //         end;
        //     end;
        // }
        // field(50002; "Ship-to Address Code"; Code[20])
        // {
        //     Caption = 'Ship-to Address Code';
        //     DataClassification = ToBeClassified;
        //     TableRelation = IF ("Ship-to Type" = CONST("Customer")) "Ship-to Address".Code where("Customer No." = field("Ship-to No.")) ELSE
        //     IF ("Ship-to Type" = CONST("Vendor")) "Order Address".Code where("Vendor No." = field("Ship-to No."));

        //     trigger OnValidate()
        //     var
        //         ShipToAddress: Record "Ship-to Address";
        //         OrderAddress: Record "Order Address";
        //     begin
        //         if ("Ship-to Address Code" = '') and ("Ship-to Address Code" <> xRec."Ship-to Address Code") then begin
        //             "Ship-to Address" := '';
        //             "Ship-to Phone No." := '';
        //             "Ship-to Contact" := '';
        //         end;
        //         if ("Ship-to Type" = "Ship-to Type"::Customer) and (ShipToAddress.Get(Rec."Ship-to No.", Rec."Ship-to Address Code")) then begin
        //             Rec."Ship-to Address" := ShipToAddress.Address;
        //             Rec."Ship-to Phone No." := ShipToAddress."Phone No.";
        //             Rec."Ship-to Contact" := ShipToAddress.Contact;
        //             Rec.Modify();
        //         end;
        //         if ("Ship-to Type" = "Ship-to Type"::Vendor) and (OrderAddress.Get(Rec."Ship-to No.", Rec."Ship-to Address Code")) then begin
        //             Rec."Ship-to Address" := OrderAddress.Address;
        //             Rec."Ship-to Phone No." := OrderAddress."Phone No.";
        //             Rec."Ship-to Contact" := OrderAddress.Contact;
        //             Rec.Modify();
        //         end;
        //     end;
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

        field(50007; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Warehouse Shipment Line"."Source No." WHERE("No." = FIELD("No.")));
        }
        field(50008; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Warehouse Shipment Line"."Destination No." WHERE("No." = FIELD("No.")));
        }
        field(50009; "Remark"; Text[60])
        {
            Caption = 'Remark';
        }
    }

}
