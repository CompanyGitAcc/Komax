tableextension 59087 "TP Production Order" extends "Production Order"
{
    fields
    {
        field(50000; "Actual Component Cost Amt."; Decimal)
        {
            Caption = 'Unit of Measure Exist';
            FieldClass = FlowField;
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE("Document No." = FIELD("No."), "Item Ledger Entry Type" = CONST(Consumption)));
        }
        field(50001; "Seclect Run Report"; Boolean)
        {
            Caption = 'Seclect Run Report';
        }

        modify("Location Code")
        {
            trigger OnAfterValidate()
            var
                Lrcd_MfgSetup: Record "Manufacturing Setup";
            begin
                GetDefaultBin;
                VALIDATE("Due Date");
                Lrcd_MfgSetup.RESET;
                Lrcd_MfgSetup.GET();
                IF Lrcd_MfgSetup."Production Location" <> '' THEN BEGIN
                    "Location Code" := Lrcd_MfgSetup."Production Location";
                END;

                GetDefaultBin;
            end;


        }

    }

    trigger OnInsert()
    var
        ManufacturingSetup: Record "Manufacturing Setup";
    begin
        ManufacturingSetup.Reset();
        ManufacturingSetup.get();
        if ManufacturingSetup."Production Location" <> '' then
            Rec."Location Code" := ManufacturingSetup."Production Location";
    end;

    procedure GetDefaultBin()
    var
        Location: Record Location;
        WMSManagement: Codeunit "WMS Management";
    begin
        "Bin Code" := '';
        IF "Source Type" <> "Source Type"::Item THEN
            EXIT;

        IF ("Location Code" <> '') AND ("Source No." <> '') THEN BEGIN
            GetLocation("Location Code");
            IF Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN
                WMSManagement.GetDefaultBin("Source No.", '', "Location Code", "Bin Code");
        END;
    end;

    procedure GetLocation(LocationCode: Code[10])
    var
        Location: Record Location;
    begin
        IF Location.Code <> LocationCode THEN
            Location.GET(LocationCode);
    end;


}
