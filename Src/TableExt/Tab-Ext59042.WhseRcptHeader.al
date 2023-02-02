tableextension 59042 "TP Warehouse Receipt Header" extends "Warehouse Receipt Header"
{
    fields
    {
        // field(50000; "Buy-from Type"; Option)
        // {
        //     Caption = 'Buy-from Type';
        //     OptionCaption = 'Customer,Vendor,Company';
        //     OptionMembers = "Customer","Vendor","Company";

        //     trigger OnValidate()
        //     begin
        //         Validate("Buy-from No.", '');
        //     end;
        // }
        // field(50001; "Buy-from No."; Code[20])
        // {
        //     Caption = 'Buy-from No.';
        //     DataClassification = ToBeClassified;
        //     TableRelation = IF ("Buy-from Type" = CONST("Customer")) Customer
        //     ELSE
        //     IF ("Buy-from Type" = CONST("Vendor")) Vendor
        //     ELSE
        //     IF ("Buy-from Type" = CONST("Company")) Location;

        //     trigger OnValidate()
        //     var
        //         Customer: Record Customer;
        //         Vendor: Record Vendor;
        //         Location: Record Location;
        //     begin
        //         if "Buy-from No." <> xRec."Buy-from No." then begin
        //             if ("Buy-from Type" = "Buy-from Type"::Customer) then begin
        //                 if Customer.Get(Rec."Buy-from No.") then begin
        //                     Rec."Buy-from Name" := Customer.Name;
        //                 end;
        //             end;
        //             if ("Buy-from Type" = "Buy-from Type"::Vendor) then begin
        //                 if Vendor.Get(Rec."Buy-from No.") then begin
        //                     Rec."Buy-from Name" := Vendor.Name;
        //                 end;
        //             end;
        //             if ("Buy-from Type" = "Buy-from Type"::Company) then begin
        //                 if Location.Get(Rec."Buy-from No.") then begin
        //                     Rec."Buy-from Name" := Location.Name;
        //                 end;
        //             end;
        //         end;
        //     end;
        // }
        // field(50004; "Buy-from Name"; Text[100])
        // {
        //     Editable = true;
        //     Caption = 'Buy-from Name';
        // }
        field(50005; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Warehouse Receipt Line"."Source No." WHERE("No." = FIELD("No.")));
        }
        //扫描条码
        field(50010; "Barcode"; Text[100])
        {
            Editable = true;
            Caption = 'Barcode';
            trigger OnValidate()
            var
                Val: array[9] of Text[20];
                POno: Code[20];
                ItemNo: Code[20];
                Qty: Decimal;
                PurchLine: Record "Purchase Line";
            begin
                if Barcode = '' then
                    exit;
                ReadBarcode(Barcode, Val);
                POno := val[2];
                ItemNo := val[5];
                Evaluate(Qty, val[7]);
                PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
                PurchLine.SetRange(Type, PurchLine.Type::Item);
                PurchLine.setrange("No.", ItemNo);
                PurchLine.SetFilter("Document No.", POno);
                if PurchLine.FindFirst() then begin
                    if PurchLine.Count > 1 then Error('lines repeated');
                    CreateWhseReceipt(Rec."No.", PurchLine);
                end else
                    Error('No purchase line is found');
                if Barcode <> '' then
                    Validate(Barcode, '');
            end;
        }
    }

    //'PL01069152;PO-22000334;1100149370;120;0326404;;1;TW;;'
    procedure ReadBarcode(BarcodeText: Text[100]; var Val: array[9] of Text[20])
    var
        Pos: Integer;
        i: Integer;
    begin
        i := 1;
        Pos := StrPos(BarcodeText, ';');
        while Pos > 0 do begin
            Val[i] := CopyStr(BarcodeText, 1, Pos - 1);
            BarcodeText := CopyStr(BarcodeText, Pos + 1);
            Pos := StrPos(BarcodeText, ';');
            i := i + 1;
        end;
    end;

    procedure CreateWhseReceipt(WhseNo: code[20]; var PurchaseLine: Record "Purchase Line")
    var
        WhseRequest: Record "Warehouse Request";
        WhseRcptHeader: Record "Warehouse Receipt Header";
        WhseRcptHeader2: Record "Warehouse Receipt Header";
        PageWhseRcptHeader: page "Warehouse Receipt";
        WhseShptLine: Record "Warehouse Receipt Line";
        CreateWhseDoc: Codeunit "Whse.-Create Source Document";
        PurchaseHeader: Record "Purchase Header";
        LastSONo: Code[20];
        LastPONo: Code[20];
        LocationCode: Code[20];
        WarehouseSetup: Record "Warehouse Setup";
    begin
        if not PurchaseLine.FindFirst() then
            exit;
        PurchaseLine.TestField(Type, PurchaseLine.Type::Item);
        LocationCode := PurchaseLine."Location Code";

        WhseRcptHeader.Get(WhseNo);

        If PurchaseLine.FindFirst() then
            repeat
                if (PurchaseLine."Document No." <> LastPONo) and (LastPONo <> '') then begin
                    error('');
                end;
                LastPONo := PurchaseLine."Document No.";
                PurchaseHeader.get(PurchaseLine."Document Type", PurchaseLine."Document No.");
                PurchaseHeader.TestField(Status, PurchaseHeader.Status::Released);
                PurchaseLine.TestField("Location Code", LocationCode);
                PurchaseLine.CalcFields("Whse. Outstanding Qty. (Base)");
                PurchaseLine.TestField("Whse. Outstanding Qty. (Base)", 0);
                if not CreateWhseDoc.PurchLine2ReceiptLine(WhseRcptHeader, PurchaseLine) then
                    error('Error');
            // if PurchaseHeader."Sell-to Customer No." <> '' then begin
            //     WhseRcptHeader.Validate("Buy-from Type", WhseRcptHeader."Buy-from Type"::Vendor);
            //     WhseRcptHeader.Validate("Buy-from No.", PurchaseHeader."Sell-to Customer No.");
            //     WhseRcptHeader.Modify();
            // end;
            until PurchaseLine.Next() = 0;
    end;

}
