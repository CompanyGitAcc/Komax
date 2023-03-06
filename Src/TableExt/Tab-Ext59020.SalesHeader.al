tableextension 59020 "TP Sales Header" extends "Sales Header"
{
    fields
    {
        //++BC190.HH
        field(50000; "Location Name"; text[100])
        {
            Caption = 'Location Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
        }
        field(50018; "Global Dimension 3 Code"; Code[20])
        {
            Caption = 'Global Dimension 3 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Global Dimension 3 Code" where("No." = field("Sell-to Customer No.")));
        }
        field(50042; "Temp Out"; Boolean)
        {
            Caption = 'Temp Out';
        }
        modify("External Document No.")
        {
            trigger OnAfterValidate()
            var
                SalesHeader2: Record "Sales Header";
                Text50000: Label 'The same External Document No. %1 already exists in order %2 ';
            begin
                TestField("External Document No.");
                //++Harvey: 检查External Document No.是否存在重复
                if Rec."Document Type" = Rec."Document Type"::Order then begin
                    SalesHeader2.Reset;
                    SalesHeader2.Setrange("Document Type", SalesHeader2."Document Type"::Order);
                    SalesHeader2.SetFilter("No.", '<>%1', Rec."No.");
                    SalesHeader2.SETRANGE("External Document No.", DelChr("External Document No.", '<>', ''));
                    IF SalesHeader2.FIND('-') THEN begin
                        repeat
                            if (Rec."External Document No." <> '') and (SalesHeader2."No." <> Rec."No.") then begin
                                if Rec."Document Type" = SalesHeader2."Document Type"::Quote then
                                    MESSAGE(Text50000, "External Document No.", SalesHeader2."No.")
                                else
                                    if Rec."Document Type" = SalesHeader2."Document Type"::Order then
                                        MESSAGE(Text50000, "External Document No.", SalesHeader2."No.");
                            end;
                        until SalesHeader2.Next() = 0;
                    end;
                end;
                //--Harvey
            end;
        }
        //--BC190.HH

        //++BC190.Deposit1.00.ALF
        field(50055; "Advance Payment %"; Decimal)
        {
            Caption = 'Advance Payment %';
        }
        field(60002; "Advance Payment Received"; Decimal)
        {
            Caption = 'Advance Payment Received';
            FieldClass = FlowField;
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Order No." = FIELD("No."), "Advance Payment" = CONST(true)));
            Editable = false;
        }
        field(60004; "Advance Payment Received (LCY)"; Decimal)
        {
            Caption = 'Advance Payment Received (LCY)';
            FieldClass = FlowField;
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Order No." = FIELD("No."), "Advance Payment" = CONST(true)));
            Editable = false;
        }
        modify("Advance Payment %") { trigger OnAfterValidate() begin VerifyUser end; }
        //--BC190.Depost1.00.ALF


        //==============================================================================
        //++NAV2009  说明：以下字段是从老系统迁移过来的字段，部分不再使用的字段已注释掉
        //==============================================================================
        field(50019; "Order Type"; Enum "Sales Order Type")
        {
            Caption = 'Order Type';
            trigger OnValidate()
            var
                lrecSalesLine: Record "Sales Line";
                Errortext001: Label 'You cant select Order type in "MT-door panel testing" or "MT-seat testing" or "MT-other function testing"';
                Confirmed: Boolean;
                Text065: Label 'Do you want to change %1?';
            begin
                TESTFIELD(Status, Status::Open);
                IF (
                    ("Order Type" = "Order Type"::"MT-seat testing") OR
                    ("Order Type" = "Order Type"::"MT-door panel testing") OR
                    ("Order Type" = "Order Type"::"MT-other function testing")) THEN
                    ERROR(Errortext001);
                IF "Document Type" = "Document Type"::Order THEN BEGIN
                    IF ("Order Type" <> xRec."Order Type")
                    THEN BEGIN
                        IF HideValidationDialog OR NOT GUIALLOWED THEN
                            Confirmed := TRUE;
                        // ELSE
                        //     Confirmed := CONFIRM(Text065, FALSE, FIELDCAPTION("Order Type"));
                        IF Confirmed THEN BEGIN
                            lrecSalesLine.RESET;
                            lrecSalesLine.SETRANGE("Document Type", "Document Type");
                            lrecSalesLine.SETRANGE("Document No.", "No.");
                            lrecSalesLine.SETFILTER("Quantity Shipped", '<>0');
                            IF lrecSalesLine.FINDFIRST THEN
                                lrecSalesLine.TESTFIELD("Quantity Shipped", 0);

                            lrecSalesLine.SETRANGE("Quantity Shipped");
                            lrecSalesLine.SETFILTER("Prepmt. Amt. Inv.", '<>0');
                            IF lrecSalesLine.FIND('-') THEN
                                lrecSalesLine.TESTFIELD("Prepmt. Amt. Inv.", 0);
                        END;
                    END;
                END;
            end;
        }

        field(50023; "Bill-to Department"; Option)
        {
            Caption = 'Bill-to Department';
            OptionCaption = ' ,Finance Dept.,Warehouse,Purchase Dept.';
            OptionMembers = " ","Finance Dept.","Warehouse","Purchase Dept.";
        }

        field(50025; "Outstanding Amount"; Decimal)
        {
            Caption = 'Outstanding Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Outstanding Amount" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.")));
        }
        field(50026; "Material Shipped not Invoiced"; Decimal)
        {
            Caption = 'Material Shipped not Invoiced';
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Shipped Not Invoiced" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.")));
        }
        field(50027; "Partial Shipped"; Option)
        {
            Caption = 'Partial Shipped';
            OptionCaption = 'Accepted,Not accepted';
            OptionMembers = "Accepted","Not accepted";
        }
        field(50028; "Bill to Contact Phone No"; Text[30])
        {
            Caption = 'Bill to Contact Phone No';
        }
        field(50029; "Sales Person"; Code[10])
        {
            Caption = 'Sales Person';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50030; "Service Person"; Code[10])
        {
            Caption = 'Service Person';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50031; "Quotes Line Discount"; Decimal)
        {
            Caption = 'Quotes Line Discount';
            trigger OnValidate()
            var
                Lrcd_SalesLine: Record "Sales Line";
            begin
                TESTFIELD(Status, Status::Open);
                IF "Document Type" = "Document Type"::Quote THEN BEGIN
                    Lrcd_SalesLine.RESET;
                    Lrcd_SalesLine.SETRANGE("Document Type", Lrcd_SalesLine."Document Type"::Quote);
                    Lrcd_SalesLine.SETRANGE("Document No.", "No.");
                    Lrcd_SalesLine.SETFILTER(Lrcd_SalesLine.Type, '<>%1', Lrcd_SalesLine.Type::" ");
                    IF Lrcd_SalesLine.FIND('-') THEN
                        REPEAT
                            Lrcd_SalesLine.VALIDATE("Line Discount %", "Quotes Line Discount");
                            Lrcd_SalesLine.MODIFY;
                        UNTIL Lrcd_SalesLine.NEXT = 0;
                END;
                COMMIT;
            end;
        }
        field(50032; "Ship-to Phone No."; Text[80])
        {
            Caption = 'Ship-to Phone No.';
        }
        field(50033; "Last Date Released"; Date)
        {
            Caption = 'Last Date Released';
        }
        field(50034; "Last Time Released"; Time)
        {
            Caption = 'Last Time Released';
        }
        field(50035; "Remark"; Text[60])
        {
            Caption = 'Remark';
        }
        field(50038; "Total Line Amount"; Decimal)
        {
            Caption = 'Total Line Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Outstanding Amount (LCY)" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.")));
        }
        field(50039; "Machine Model"; Code[30])
        {
            Caption = 'Machine Model';
            TableRelation = "Machine Model";
        }
        field(50040; "Print Flag"; Integer)
        {
            Caption = 'Print Flag';
        }
        field(50041; "Amount Excl VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line".Amount WHERE("Document Type" = FIELD("Document Type"),
                                                         "Document No." = FIELD("No.")));
            Caption = 'Amount Excl VAT';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50043; "Order No."; Code[20])
        {
            Caption = 'Order NO.';
        }
        field(50044; "Everything Is Invoiced"; Boolean)
        {
            Caption = 'Everything Is Invoiced';
        }
        field(50045; "Completely Invoiced"; Boolean)
        {
            Caption = 'Completely Invoiced';
        }

        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                Customer: Record Customer;
                Lrcd_ShipAddress: Record "Ship-to Address";
            begin
                if Customer.get("Sell-to Customer No.") then begin
                    //     // "Sales Person" := Cust."Sales Person";
                    //     "Service Person" := Customer."Service Person";

                    //     Lrcd_ShipAddress.RESET;
                    //     Lrcd_ShipAddress.SETRANGE(Lrcd_ShipAddress."Customer No.", "Sell-to Customer No.");
                    //     Lrcd_ShipAddress.SETFILTER(Lrcd_ShipAddress.Code, '<>%1', '');
                    //     IF Lrcd_ShipAddress.FIND('-') THEN
                    //         VALIDATE("Ship-to Code", Lrcd_ShipAddress.Code)
                    //     ELSE
                    //         VALIDATE("Ship-to Code", '');
                    //++BC190.Deposit1.00
                    "Advance Payment %" := Customer."Advance Payment %";
                    //--BC190.Deposit1.00
                end;
            end;
        }

        modify("Bill-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                Cust: Record Customer;
                SkipBillToContact: Boolean;
            begin
                "Bill-to Address" := Cust."Bill to Address";
                "Bill to Contact Phone No" := Cust."Bill to Contact Phone No.";
                "Bill-to Department" := Cust."Bill-to Department";
                IF NOT SkipBillToContact THEN
                    "Bill-to Contact" := Cust."Bill to Contact";
            end;
        }
        modify("Ship-to Code")
        {
            trigger OnAfterValidate()
            var
                ShipToAddr: Record "Ship-to Address";
                Cust: Record Customer;
            begin
                if ShipToAddr.Get("Sell-to Customer No.", "Ship-to Code") then begin
                    "Ship-to Phone No." := ShipToAddr."Phone No.";
                end;
            end;
        }

    }
    procedure VerifyUser()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        UserSetup.TestField("Finance Controller");
    end;

    procedure GetCreatedByName(): Code[50]
    var
        User: Record User;
    begin
        If User.Get(Rec.SystemCreatedBy) Then
            exit(User."User Name");
    end;
}
