tableextension 59025 "TP Purchase Header" extends "Purchase Header"
{
    fields
    {
        modify("Expected Receipt Date")
        {
            trigger OnAfterValidate()
            var
                WayofDispatch: Record "Way Of Dispatch";
                PurchaseHeader: Record "Purchase Header";
            begin
                if WayofDispatch.get(Rec."Way of Dispatch") then begin
                    Rec.Validate("Requested Delivery Date", CalcDate(WayofDispatch."Dispatch Time", Rec."Expected Receipt Date"));
                end;
            end;
        }
        field(50001; "Location Name"; text[100])
        {
            Caption = 'Location Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
        }
        field(50002; "Work Description"; BLOB)
        {
            Caption = 'Work Description';
            DataClassification = ToBeClassified;
        }
        // field(50003; "Prepared By"; text[100])
        // {
        //     Caption = 'Prepared By';
        //     TableRelation = Employee;
        // }

        //++BC190.Deposit1.00.ALF
        field(50050; "Deposit Type"; Enum "Deposit Type")
        {
            Caption = 'Deposit Type';
            DataClassification = ToBeClassified;
        }
        field(50053; "Vendor Bank Account"; Code[20])
        {
            Caption = 'Vendor Bank Account';
            DataClassification = ToBeClassified;
            TableRelation = "Vendor Bank Account".Code WHERE("Vendor No." = FIELD("Pay-to Vendor No."));
        }
        field(50054; "Vendor Bank Name"; Text[30])
        {
            Caption = 'Vendor Bank Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        //--BC190.Deposit1.00.ALF

        //==============================================================================
        //++NAV2009  说明：以下字段是从老系统迁移过来的字段，部分不再使用的字段已注释掉
        //==============================================================================        
        field(50004; "Order Type"; Enum "Purchase Order Type")
        {
            Caption = 'Order Type';

        }
        field(50005; "Partial Delivery"; Option)
        {
            Caption = 'Partial Delivery';
            OptionCaption = 'Accepted,Not accepted';
            OptionMembers = "Accepted","Not accepted";
        }
        field(50006; "Forwarder"; Code[20])
        {
            Caption = 'Forwarder';
            TableRelation = "Shipping Agent";
        }
        field(50007; "Way of Dispatch"; Code[20])
        {
            Caption = 'Way of Dispatch';
            TableRelation = "Way Of Dispatch";
        }
        // field(50008; "JinSui Invoice No."; Code[20])
        // {
        //     Caption = 'JinSui Invoice No.';
        // }
        field(50009; "Everything Is Invoiced"; Boolean)
        {
            Caption = 'Everything Is Invoiced';
        }
        field(50010; "Outstanding Amount (Inc. VAT)"; Decimal)
        {
            Caption = 'Outstanding Amount (Inc. VAT)';
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Outstanding Amount" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.")));
        }
        field(50011; "Mat. Rcvd not Ivcd (Inc. VAT)"; Decimal)
        {
            Caption = 'Mat. Rcvd not Ivcd (Inc. VAT)';
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Amt. Rcd. Not Invoiced" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.")));
        }
        field(50012; "Payment Term Remark"; Text[80])
        {
            Caption = 'Payment Term Remark';
        }
        field(50013; Remark; Text[60])
        {
            Caption = 'Remark';
        }
        field(50014; "OC Date"; Date)
        {
            Caption = 'OC Date';
            trigger OnValidate()
            var
                PurchaseLine: Record "Purchase Line";
            begin
                if not confirm(Text001) then
                    exit;
                PurchaseLine.Reset();
                PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
                PurchaseLine.SetRange("Document No.", "No.");
                if PurchaseLine.FindFirst() then
                    repeat
                        PurchaseLine."OC Date" := Rec."OC Date";
                        PurchaseLine.Modify();
                    until PurchaseLine.Next() = 0;
            end;
        }
        field(50015; "Customs Supervision"; Boolean)
        {
            Caption = 'Customs Supervision';
        }

        // field(50017; "Promise Delivery Date"; Date)
        // {
        //     Caption = 'Promise Delivery Date';
        //     trigger OnValidate()
        //     var
        //         PurchaseLine: Record "Purchase Line";
        //     begin
        //         PurchaseLine.Reset();
        //         PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        //         PurchaseLine.SetRange("Document No.", "No.");
        //         if PurchaseLine.FindFirst() then
        //             repeat
        //                 PurchaseLine."Promise Delivery Date" := Rec."Promise Delivery Date";
        //                 PurchaseLine.Modify();
        //             until PurchaseLine.Next() = 0;
        //     end;
        // }
        field(50018; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
            trigger OnValidate()
            var
                PurchaseLine: Record "Purchase Line";
            begin
                if not confirm(Text001) then
                    exit;
                PurchaseLine.Reset();
                PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
                PurchaseLine.SetRange("Document No.", "No.");
                if PurchaseLine.FindFirst() then
                    repeat
                        PurchaseLine."Requested Delivery Date" := Rec."Requested Delivery Date";
                        PurchaseLine.Modify();
                    until PurchaseLine.Next() = 0;
            end;
        }
        field(60000; "Outstanding Quantity"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Outstanding Quantity" WHERE("Document Type" = CONST(Order), "Document No." = FIELD("No.")));
            Caption = 'Outstanding Quantity';
            FieldClass = FlowField;
        }


        modify("Vendor Invoice No.")
        {
            trigger OnAfterValidate()
            var
                PurchaseHeader2: Record "Purchase Header";
                Text50000: Label 'The same Vendor Invoice No. %1 already exists in order %2 ';
            begin
                PurchaseHeader2.INIT;
                PurchaseHeader2.SETRANGE("Vendor Invoice No.", "Vendor Invoice No.");
                IF PurchaseHeader2.FIND('-') THEN begin
                    //++Harvey
                    repeat
                        if (Rec."Vendor Invoice No." <> '') and (PurchaseHeader2."No." <> Rec."No.") then begin
                            Error(Text50000, "Vendor Invoice No.", PurchaseHeader2."No.");
                        end;
                    until PurchaseHeader2.Next() = 0;
                    //--Harvey
                end;
            end;
        }

        modify("Location Code")
        {
            trigger OnAfterValidate()
            begin
                Rec.UpdateShipToAddress();
            end;
        }
    }

    procedure GetCreatedByName(): Code[50]
    var
        User: Record User;
    begin
        If User.Get(Rec.SystemCreatedBy) Then
            exit(User."User Name");
    end;

    procedure SetWorkDescription(NewWorkDescription: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Work Description");
        "Work Description".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription);
        Modify;
    end;

    procedure GetWorkDescription() WorkDescription: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Work Description");
        "Work Description".CreateInStream(InStream, TEXTENCODING::UTF8);
        if not TypeHelper.TryReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator(), WorkDescription) then
            Message(ReadingDataSkippedMsg, FieldCaption("Work Description"));
    end;

    var
        ReadingDataSkippedMsg: Label 'Loading field %1 will be skipped because there was an error when reading the data.\To fix the current data, contact your administrator.\Alternatively, you can overwrite the current data by entering data in the field.', Comment = '%1=field caption';
        Text001: Label 'Will you modify this filed in purchase line?';
}
