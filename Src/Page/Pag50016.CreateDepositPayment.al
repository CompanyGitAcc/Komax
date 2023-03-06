page 50016 "Create Deposit Payment"
{
    // #1 pay deposit in sales order
    //    Add function Setvalue
    //    Add Global Variables: SalesHeader, Deposit, etc.
    //    Add Post Payment Journal
    // 
    // #2 change SaveValue property to No, otherwise the SetValue function will become malfunction

    Caption = 'Create Payment';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group(Group1)
            {
                field("Template Name"; JournalTemplateName)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Template Name';
                    Editable = false;
                    ShowMandatory = true;
                    TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Payments));
                    ToolTip = 'Specifies the name of the journal template.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GenJnlTemplate: Record "Gen. Journal Template";
                        GeneralJournalTemplates: Page "General Journal Templates";
                    begin
                        GenJnlTemplate.FILTERGROUP(2);
                        GenJnlTemplate.SETRANGE(Type, GenJnlTemplate.Type::Payments);
                        GenJnlTemplate.FILTERGROUP(0);
                        GeneralJournalTemplates.SETTABLEVIEW(GenJnlTemplate);
                        GeneralJournalTemplates.LOOKUPMODE := TRUE;
                        IF GeneralJournalTemplates.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            GeneralJournalTemplates.GETRECORD(GenJnlTemplate);
                            JournalTemplateName := GenJnlTemplate.Name;
                            BatchSelection(JournalTemplateName, JournalBatchName);
                        END;
                    end;

                    trigger OnValidate()
                    var
                        GenJnlTemplate: Record "Gen. Journal Template";
                    begin
                        GenJnlTemplate.GET(JournalTemplateName);
                        BatchSelection(JournalTemplateName, JournalBatchName);
                    end;
                }
                field("Batch Name"; JournalBatchName)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Batch Name';
                    //Deposit1.00
                    //Editable = false;
                    Editable = true;
                    //Deposit1.00
                    ShowMandatory = true;
                    TableRelation = "Gen. Journal Batch".Name WHERE("Template Type" = CONST(Payments),
                                                                     Recurring = CONST(false));
                    ToolTip = 'Specifies the name of the journal batch.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GenJournalBatch: Record "Gen. Journal Batch";
                        GeneralJournalBatches: Page "General Journal Batches";
                    begin
                        GenJournalBatch.FILTERGROUP(2);
                        GenJournalBatch.SETRANGE("Journal Template Name", JournalTemplateName);
                        GenJournalBatch.FILTERGROUP(0);

                        GeneralJournalBatches.SETTABLEVIEW(GenJournalBatch);
                        GeneralJournalBatches.LOOKUPMODE := TRUE;
                        IF GeneralJournalBatches.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            GeneralJournalBatches.GETRECORD(GenJournalBatch);
                            JournalBatchName := GenJournalBatch.Name;
                            BatchSelection(JournalTemplateName, JournalBatchName);
                        END;
                    end;

                    trigger OnValidate()
                    begin
                        IF JournalBatchName <> '' THEN
                            BatchSelection(JournalTemplateName, JournalBatchName);
                    end;
                }
                field("Posting Date"; PostingDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posting Date';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the entry''s posting date.';
                }
                field("Starting Document No."; NextDocNo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Starting Document No.';
                    Editable = false;
                    ShowMandatory = true;
                    ToolTip = 'Specifies a document number for the journal line.';
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field(ExtDocNo; ExtDocNo)
                {
                    ApplicationArea = all;
                }
                field("Bank Account"; BalAccountNo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bank Account';
                    TableRelation = "Bank Account";
                    ToolTip = 'Specifies the bank account to which a balancing entry for the journal line will be posted.';
                }
                field("Payment Type"; BankPaymentType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Payment Type';
                    OptionCaption = ' ,Computer Check,Manual Check,Electronic Payment,Electronic Payment-IAT';
                    ToolTip = 'Specifies the code for the payment type to be used for the entry on the payment journal line.';
                    Visible = false;
                }
                //++BC190.Deposit
                field("Transaction Type"; TransType)
                {
                    Caption = 'Transaction Type';
                    OptionCaption = 'Receive Customer Payment,Refund Customer Payment,Pay Vendor,Refund Vendor';
                }
                field(PaymentMethod; PaymentMethod)
                {
                    TableRelation = "Payment Method";
                }
                field("Currency Code"; CurrencyCode)
                {
                    Caption = 'Currency Code';
                    Editable = false;
                }
                field(Amount; AmountToHandle)
                {
                    Caption = 'Amount';
                }
                //++BC190.Deposit
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJnlManagement: Codeunit "GenJnlManagement";
    begin
        PostingDate := WORKDATE;

        IF NOT GenJnlTemplate.GET(JournalTemplateName) THEN
            CLEAR(JournalTemplateName);
        IF NOT GenJournalBatch.GET(JournalTemplateName, JournalBatchName) THEN
            CLEAR(JournalBatchName);
        //ALF
        BatchSelection(JournalTemplateName, JournalBatchName);
        // IF JournalTemplateName = '' THEN
        //     IF TemplateSelectionSimple(GenJnlTemplate, GenJnlTemplate.Type::Payments, FALSE) THEN BEGIN   //TemplateSelectionSimple改成調用本地
        //         JournalTemplateName := GenJnlTemplate.Name;
        //         BatchSelection(JournalTemplateName, JournalBatchName);
        //     END;

        // IF JournalBatchName = '' THEN
        //     BatchSelection(JournalTemplateName, JournalBatchName);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction = ACTION::OK THEN BEGIN
            IF JournalBatchName = '' THEN
                ERROR(BatchNumberNotFilledErr);
            IF FORMAT(PostingDate) = '' THEN
                ERROR(PostingDateNotFilledErr);
            IF NextDocNo = '' THEN
                ERROR(SpecifyStartingDocNumErr);
        END;
    end;

    var
        GenJnlManagement: Codeunit "GenJnlManagement";
        PostingDate: Date;
        BalAccountNo: Code[20];
        NextDocNo: Code[20];
        JournalBatchName: Code[10];
        JournalTemplateName: Code[10];
        BankPaymentType: Option " ","Computer Check","Manual Check","Electronic Payment","Electronic Payment-IAT";
        StartingDocumentNoErr: Label 'Starting Document No.';
        BatchNumberNotFilledErr: Label 'You must fill the Batch Name field.';
        PostingDateNotFilledErr: Label 'You must fill the Posting Date field.';
        SpecifyStartingDocNumErr: Label 'In the Starting Document No. field, specify the first document number to be used.';
        MessageToRecipientMsg: Label 'Payment of %1 %2 ', Comment = '%1 document type, %2 Document No.';
        EarlierPostingDateErr: Label 'You cannot create a payment with an earlier posting date for %1 %2.', Comment = '%1 - Document Type, %2 - Document No.. You cannot create a payment with an earlier posting date for an Invoice INV-001.';
        //=====================================================================================
        //++Deposit
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
        CurrencyCode: Code[20];
        IsDeposit: Boolean;
        TransType: Option "Receive Customer Deposit","Refund Customer Deposit","Pay Vendor Deposit","Refund Vendor Deposit";
        AmountToHandle: Decimal;
        Vendor: Record "Vendor";
        Customer: Record "Customer";
        NosMgt: Codeunit "NoSeriesManagement";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        Description: Text[100];
        ExtDocNo: Code[20];
        PaymentMethod: Code[20];
        UserSetup: Record "User Setup";
        //以下Text用于CheckTemplateName函数
        Text000: Label 'Fixed Asset G/L Journal';
        Text001: Label '%1 journal';
        Text002: Label 'RECURRING';
        Text003: Label 'Recurring General Journal';
        Text004: Label 'DEFAULT';
        Text005: Label 'Default Journal';
    //--Deposit

    procedure GetPostingDate(): Date
    begin
        EXIT(PostingDate);
    end;

    procedure GetBankAccount(): Text
    begin
        EXIT(FORMAT(BalAccountNo));
    end;

    procedure GetBankPaymentType(): Integer
    begin
        EXIT(BankPaymentType);
    end;

    procedure GetBatchNumber(): Code[10]
    begin
        EXIT(JournalBatchName);
    end;

    procedure GetTemplateName(): Code[10]
    begin
        EXIT(JournalTemplateName);
    end;

    procedure MakeGenJnlLines(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    var
        GenJnlLine: Record "Gen. Journal Line";
        Vendor: Record "Vendor";
        TempPaymentBuffer: Record "Payment Buffer" temporary;
        PaymentAmt: Decimal;
        SummarizePerVend: Boolean;
    begin
        TempPaymentBuffer.RESET;
        TempPaymentBuffer.DELETEALL;

        IF VendorLedgerEntry.FIND('-') THEN
            REPEAT
                IF PostingDate < VendorLedgerEntry."Posting Date" THEN
                    ERROR(STRSUBSTNO(EarlierPostingDateErr, VendorLedgerEntry."Document Type", VendorLedgerEntry."Document No."));
                VendorLedgerEntry.CALCFIELDS("Remaining Amount");
                IF VendorLedgerEntry."Applies-to ID" = '' THEN BEGIN
                    TempPaymentBuffer."Vendor No." := VendorLedgerEntry."Vendor No.";
                    TempPaymentBuffer."Currency Code" := VendorLedgerEntry."Currency Code";

                    IF VendorLedgerEntry."Payment Method Code" = '' THEN BEGIN
                        IF Vendor.GET(VendorLedgerEntry."Vendor No.") THEN
                            TempPaymentBuffer."Payment Method Code" := Vendor."Payment Method Code";
                    END ELSE
                        TempPaymentBuffer."Payment Method Code" := VendorLedgerEntry."Payment Method Code";

                    TempPaymentBuffer.CopyFieldsFromVendorLedgerEntry(VendorLedgerEntry);

                    OnUpdateTempBufferFromVendorLedgerEntry(TempPaymentBuffer, VendorLedgerEntry);
                    TempPaymentBuffer."Dimension Entry No." := 0;
                    TempPaymentBuffer."Global Dimension 1 Code" := '';
                    TempPaymentBuffer."Global Dimension 2 Code" := '';
                    TempPaymentBuffer."Dimension Set ID" := 0;
                    TempPaymentBuffer."Vendor Ledg. Entry No." := VendorLedgerEntry."Entry No.";
                    TempPaymentBuffer."Vendor Ledg. Entry Doc. Type" := VendorLedgerEntry."Document Type";

                    IF CheckCalcPmtDiscGenJnlVend(VendorLedgerEntry."Remaining Amount", VendorLedgerEntry, 0, FALSE) THEN
                        PaymentAmt := -(VendorLedgerEntry."Remaining Amount" - VendorLedgerEntry."Remaining Pmt. Disc. Possible")
                    ELSE
                        PaymentAmt := -VendorLedgerEntry."Remaining Amount";

                    TempPaymentBuffer.RESET;
                    TempPaymentBuffer.SETRANGE("Vendor No.", VendorLedgerEntry."Vendor No.");
                    TempPaymentBuffer.SETRANGE("Vendor Ledg. Entry Doc. Type", TempPaymentBuffer."Vendor Ledg. Entry Doc. Type");
                    IF TempPaymentBuffer.FIND('-') THEN BEGIN
                        TempPaymentBuffer.Amount += PaymentAmt;
                        SummarizePerVend := TRUE;
                        TempPaymentBuffer.MODIFY;
                    END ELSE BEGIN
                        TempPaymentBuffer."Document No." := NextDocNo;
                        NextDocNo := INCSTR(NextDocNo);
                        TempPaymentBuffer.Amount := PaymentAmt;
                        TempPaymentBuffer.INSERT;
                    END;
                    VendorLedgerEntry."Applies-to ID" := TempPaymentBuffer."Document No.";

                    VendorLedgerEntry."Amount to Apply" := VendorLedgerEntry."Remaining Amount";
                    CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", VendorLedgerEntry);
                END;
            UNTIL VendorLedgerEntry.NEXT = 0;

        CopyTempPaymentBufferToGenJournalLines(TempPaymentBuffer, GenJnlLine, SummarizePerVend);
    end;

    local procedure CopyTempPaymentBufferToGenJournalLines(var TempPaymentBuffer: Record "Payment Buffer" temporary; var GenJnlLine: Record "Gen. Journal Line"; SummarizePerVend: Boolean)
    var
        Vendor: Record "Vendor";
        GenJournalTemplate: Record "Gen. Journal Template";
        GenJournalBatch: Record "Gen. Journal Batch";
        BalAccType: Option "G/L Account",Customer,Vendor,"Bank Account";
        LastLineNo: Integer;
    begin
        GenJnlLine.LOCKTABLE;
        GenJournalBatch.GET(JournalTemplateName, JournalBatchName);
        GenJournalTemplate.GET(JournalTemplateName);
        GenJnlLine.SETRANGE("Journal Template Name", JournalTemplateName);
        GenJnlLine.SETRANGE("Journal Batch Name", JournalBatchName);
        IF GenJnlLine.FINDLAST THEN BEGIN
            LastLineNo := GenJnlLine."Line No.";
            GenJnlLine.INIT;
        END;

        TempPaymentBuffer.RESET;
        TempPaymentBuffer.SETCURRENTKEY("Document No.");
        TempPaymentBuffer.SETFILTER(
          "Vendor Ledg. Entry Doc. Type", '<>%1&<>%2', TempPaymentBuffer."Vendor Ledg. Entry Doc. Type"::Refund,
          TempPaymentBuffer."Vendor Ledg. Entry Doc. Type"::Payment);
        IF TempPaymentBuffer.FIND('-') THEN
            REPEAT
                WITH GenJnlLine DO BEGIN
                    INIT;
                    VALIDATE("Journal Template Name", JournalTemplateName);
                    VALIDATE("Journal Batch Name", JournalBatchName);
                    LastLineNo += 10000;
                    "Line No." := LastLineNo;
                    IF TempPaymentBuffer."Vendor Ledg. Entry Doc. Type" = TempPaymentBuffer."Vendor Ledg. Entry Doc. Type"::Invoice THEN
                        "Document Type" := "Document Type"::Payment
                    ELSE
                        "Document Type" := "Document Type"::Refund;
                    "Posting No. Series" := GenJournalBatch."Posting No. Series";
                    "Document No." := TempPaymentBuffer."Document No.";
                    "Account Type" := "Account Type"::Vendor;

                    SetHideValidation(TRUE);
                    VALIDATE("Posting Date", PostingDate);
                    VALIDATE("Account No.", TempPaymentBuffer."Vendor No.");

                    IF Vendor."No." <> TempPaymentBuffer."Vendor No." THEN
                        Vendor.GET(TempPaymentBuffer."Vendor No.");
                    Description := Vendor.Name;

                    "Bal. Account Type" := BalAccType::"Bank Account";
                    VALIDATE("Bal. Account No.", BalAccountNo);
                    VALIDATE("Currency Code", TempPaymentBuffer."Currency Code");

                    "Message to Recipient" := GetMessageToRecipient(SummarizePerVend, TempPaymentBuffer);
                    "Bank Payment Type" := BankPaymentType;
                    "Applies-to ID" := "Document No.";

                    "Source Code" := GenJournalTemplate."Source Code";
                    "Reason Code" := GenJournalBatch."Reason Code";
                    "Source Line No." := TempPaymentBuffer."Vendor Ledg. Entry No.";
                    "Shortcut Dimension 1 Code" := TempPaymentBuffer."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := TempPaymentBuffer."Global Dimension 2 Code";
                    "Dimension Set ID" := TempPaymentBuffer."Dimension Set ID";

                    VALIDATE(Amount, TempPaymentBuffer.Amount);

                    "Applies-to Doc. Type" := TempPaymentBuffer."Vendor Ledg. Entry Doc. Type";
                    "Applies-to Doc. No." := TempPaymentBuffer."Vendor Ledg. Entry Doc. No.";

                    VALIDATE("Payment Method Code", TempPaymentBuffer."Payment Method Code");

                    TempPaymentBuffer.CopyFieldsToGenJournalLine(GenJnlLine);

                    OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer(GenJnlLine, TempPaymentBuffer);
                    UpdateDimensions(GenJnlLine, TempPaymentBuffer);
                    INSERT;
                END;
            UNTIL TempPaymentBuffer.NEXT = 0;
    end;

    local procedure UpdateDimensions(var GenJnlLine: Record "Gen. Journal Line"; TempPaymentBuffer: Record "Payment Buffer" temporary)
    var
        DimBuf: Record "Dimension Buffer";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimVal: Record "Dimension Value";
        DimBufMgt: Codeunit "Dimension Buffer Management";
        DimMgt: Codeunit "DimensionManagement";
        NewDimensionID: Integer;
        DimSetIDArr: array[10] of Integer;
    begin
        WITH GenJnlLine DO BEGIN
            NewDimensionID := "Dimension Set ID";

            DimBuf.RESET;
            DimBuf.DELETEALL;
            DimBufMgt.GetDimensions(TempPaymentBuffer."Dimension Entry No.", DimBuf);
            IF DimBuf.FINDSET THEN
                REPEAT
                    DimVal.GET(DimBuf."Dimension Code", DimBuf."Dimension Value Code");
                    TempDimSetEntry."Dimension Code" := DimBuf."Dimension Code";
                    TempDimSetEntry."Dimension Value Code" := DimBuf."Dimension Value Code";
                    TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
                    TempDimSetEntry.INSERT;
                UNTIL DimBuf.NEXT = 0;
            NewDimensionID := DimMgt.GetDimensionSetID(TempDimSetEntry);
            "Dimension Set ID" := NewDimensionID;

            CreateDim(
              DimMgt.TypeToTableID1("Account Type"), "Account No.",
              DimMgt.TypeToTableID1("Bal. Account Type"), "Bal. Account No.",
              DATABASE::Job, "Job No.",
              DATABASE::"Salesperson/Purchaser", "Salespers./Purch. Code",
              DATABASE::Campaign, "Campaign No.");
            IF NewDimensionID <> "Dimension Set ID" THEN BEGIN
                DimSetIDArr[1] := "Dimension Set ID";
                DimSetIDArr[2] := NewDimensionID;
                "Dimension Set ID" :=
                  DimMgt.GetCombinedDimensionSetID(DimSetIDArr, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            END;

            DimMgt.GetDimensionSet(TempDimSetEntry, "Dimension Set ID");
            DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code",
              "Shortcut Dimension 2 Code");
        END;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateTempBufferFromVendorLedgerEntry(var TempPaymentBuffer: Record "Payment Buffer" temporary; VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer(var GenJournalLine: Record "Gen. Journal Line"; TempPaymentBuffer: Record "Payment Buffer" temporary)
    begin
    end;

    local procedure SetNextNo(GenJournalBatchNoSeries: Code[20])
    var
        GenJournalLine: Record "Gen. Journal Line";
        NoSeriesMgt: Codeunit "NoSeriesManagement";
    begin
        IF GenJournalBatchNoSeries = '' THEN
            NextDocNo := ''
        ELSE BEGIN
            GenJournalLine.SETRANGE("Journal Template Name", JournalTemplateName);
            GenJournalLine.SETRANGE("Journal Batch Name", JournalBatchName);
            IF GenJournalLine.FINDLAST THEN
                NextDocNo := INCSTR(GenJournalLine."Document No.")
            ELSE
                NextDocNo := NoSeriesMgt.GetNextNo(GenJournalBatchNoSeries, PostingDate, FALSE);
            CLEAR(NoSeriesMgt);
        END;
    end;

    procedure CheckCalcPmtDiscGenJnlVend(RemainingAmt: Decimal; OldVendLedgEntry2: Record "Vendor Ledger Entry"; ApplnRoundingPrecision: Decimal; CheckAmount: Boolean): Boolean
    var
        NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer";
        OldCVLedgEntryBuf2: Record "CV Ledger Entry Buffer";
        PaymentToleranceManagement: Codeunit "Payment Tolerance Management";
        DocumentType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
    begin
        NewCVLedgEntryBuf."Document Type" := DocumentType::Payment;
        NewCVLedgEntryBuf."Posting Date" := PostingDate;
        NewCVLedgEntryBuf."Remaining Amount" := RemainingAmt;
        OldCVLedgEntryBuf2.CopyFromVendLedgEntry(OldVendLedgEntry2);
        EXIT(
          PaymentToleranceManagement.CheckCalcPmtDisc(
            NewCVLedgEntryBuf, OldCVLedgEntryBuf2, ApplnRoundingPrecision, FALSE, CheckAmount));
    end;

    local procedure GetMessageToRecipient(SummarizePerVend: Boolean; TempPaymentBuffer: Record "Payment Buffer" temporary): Text[140]
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        CompanyInformation: Record "Company Information";
    begin
        IF SummarizePerVend THEN BEGIN
            CompanyInformation.GET;
            EXIT(CompanyInformation.Name);
        END;

        VendorLedgerEntry.GET(TempPaymentBuffer."Vendor Ledg. Entry No.");
        IF VendorLedgerEntry."Message to Recipient" <> '' THEN
            EXIT(VendorLedgerEntry."Message to Recipient");

        EXIT(
          STRSUBSTNO(
            MessageToRecipientMsg,
            TempPaymentBuffer."Vendor Ledg. Entry Doc. Type",
            TempPaymentBuffer."Applies-to Ext. Doc. No."));
    end;

    local procedure BatchSelection(CurrentJnlTemplateName: Code[10]; var CurrentJnlBatchName: Code[10])
    var
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        CheckTemplateName(CurrentJnlTemplateName, CurrentJnlBatchName);
        GenJournalBatch.GET(CurrentJnlTemplateName, CurrentJnlBatchName);
        SetNextNo(GenJournalBatch."No. Series");
    end;

    //=======================================================================================================
    //Deposit: Create Payment for Deposit
    //
    //=======================================================================================================
    procedure SetValue(OrderNoP: Code[20]; TypeP: Integer)
    begin
        //pType: 1- customer pay 2-customer refund 3- vendor pay 4- vendor refund
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD(Cashier, TRUE);
        IF TypeP IN [1, 2] THEN BEGIN
            SalesHeader.GET(SalesHeader."Document Type"::Order, OrderNoP);
            SalesHeader.TESTFIELD("Bill-to Customer No.");
            JournalTemplateName := 'CASH RECE';
            JournalBatchName := 'DEFAULT';
            //SalesHeader.TESTFIELD("Customer Bank Account");
            // IF SalesHeader."Deposit Type" = SalesHeader."Deposit Type"::"No Deposit" THEN
            //     ERROR('No deposit is setup for order%1', SalesHeader."No.");

            // IF SalesHeader."Deposit Type" = SalesHeader."Deposit Type"::"Customer Pay" THEN
            //     BalAccountNo := 'DEPOSIT';
            // IF SalesHeader."Deposit Type" = SalesHeader."Deposit Type"::"Company Pay" THEN BEGIN
            //     SalesHeader.TESTFIELD("Our Bank Account");
            //     BalAccountNo := SalesHeader."Our Bank Account";
            // END;
        END;
        IF TypeP IN [3, 4] THEN BEGIN
            PurchHeader.GET(SalesHeader."Document Type"::Order, OrderNoP);
            PurchHeader.TESTFIELD("Pay-to Vendor No.");
            PurchHeader.TESTFIELD("Vendor Bank Account");
            IF PurchHeader."Deposit Type" = PurchHeader."Deposit Type"::"No Deposit" THEN
                ERROR('No deposit is setup for order%1', SalesHeader."No.");

            // IF SalesHeader."Deposit Type" = PurchHeader."Deposit Type"::"Customer Pay" THEN
            //     BalAccountNo := 'DEPOSIT';
            // IF PurchHeader."Deposit Type" = PurchHeader."Deposit Type"::"Company Pay" THEN BEGIN
            //     PurchHeader.TESTFIELD("Our Bank Account");
            //     BalAccountNo := SalesHeader."Our Bank Account";
            // END;
            PurchHeader.TESTFIELD("Pay-to Vendor No.");
            PurchHeader.TESTFIELD("Vendor Bank Account");
        END;

        CurrencyCode := SalesHeader."Currency Code";
        CASE TypeP OF
            1:
                TransType := TransType::"Receive Customer Deposit";
            2:
                TransType := TransType::"Refund Customer Deposit";
            3:
                TransType := TransType::"Pay Vendor Deposit";
            4:
                TransType := TransType::"Refund Vendor Deposit";
        END;

        IsDeposit := TRUE;
    end;

    procedure PostDepositJournal()
    var
        Vendor: Record "Vendor";
        GenJournalTemplate: Record "Gen. Journal Template";
        GenJournalBatch: Record "Gen. Journal Batch";
        BalAccType: Option "G/L Account",Customer,Vendor,"Bank Account";
        LastLineNo: Integer;
        GenJnlLine: Record "Gen. Journal Line";
    begin
        IF BalAccountNo = '' THEN
            ERROR('Please input bank account.');
        IF AmountToHandle = 0 THEN
            ERROR('Please input amount.');
        IF TransType IN [TransType::"Receive Customer Deposit", TransType::"Pay Vendor Deposit"] THEN
            IF AmountToHandle < 0 THEN
                ERROR('Amount cannot be negative');
        IF TransType IN [TransType::"Refund Customer Deposit", TransType::"Refund Vendor Deposit"] THEN
            IF AmountToHandle > 0 THEN
                ERROR('Amount cannot be positive');

        GenJnlLine.LOCKTABLE;
        GenJournalBatch.GET(JournalTemplateName, JournalBatchName);
        GenJournalTemplate.GET(JournalTemplateName);
        GenJnlLine.SETRANGE("Journal Template Name", JournalTemplateName);
        GenJnlLine.SETRANGE("Journal Batch Name", JournalBatchName);
        IF GenJnlLine.FINDLAST THEN BEGIN
            GenJnlLine.DELETEALL;
            LastLineNo := 0;
            GenJnlLine.INIT;
        END;

        GenJnlLine.INIT;
        GenJnlLine.VALIDATE("Journal Template Name", JournalTemplateName);
        GenJnlLine.VALIDATE("Journal Batch Name", JournalBatchName);
        LastLineNo += 10000;
        GenJnlLine."Line No." := LastLineNo;

        //"Posting No. Series" := GenJournalBatch."Posting No. Series";
        GenJournalBatch.TestField("No. Series");
        GenJnlLine."Document No." := NosMgt.GetNextNo(GenJournalBatch."No. Series", WORKDATE, FALSE);
        GenJnlLine.SetHideValidation(TRUE);
        GenJnlLine.VALIDATE("Posting Date", PostingDate);

        CASE TransType OF
            TransType::"Receive Customer Deposit":
                BEGIN
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                    GenJnlLine."Account No." := BalAccountNo;
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Customer;
                    GenJnlLine."Bal. Account No." := SalesHeader."Bill-to Customer No.";
                    GenJnlLine.Description := SalesHeader."Bill-to Name";
                END;
            TransType::"Refund Customer Deposit":
                BEGIN
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                    GenJnlLine."Account No." := BalAccountNo;
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Customer;
                    GenJnlLine."Bal. Account No." := SalesHeader."Bill-to Customer No.";
                    GenJnlLine.Description := SalesHeader."Bill-to Name";
                END;
            TransType::"Pay Vendor Deposit":
                BEGIN
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
                    GenJnlLine."Account No." := PurchHeader."Pay-to Vendor No.";
                    GenJnlLine."Recipient Bank Account" := PurchHeader."Vendor Bank Account";
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
                    GenJnlLine."Bal. Account No." := BalAccountNo;
                    GenJnlLine.Description := PurchHeader."Pay-to Name";
                END;
            TransType::"Refund Vendor Deposit":
                BEGIN
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
                    GenJnlLine."Account No." := PurchHeader."Pay-to Vendor No.";
                    GenJnlLine."Recipient Bank Account" := PurchHeader."Vendor Bank Account";
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
                    GenJnlLine."Bal. Account No." := BalAccountNo;
                    GenJnlLine.Description := PurchHeader."Pay-to Name";
                END;
        END;

        GenJnlLine.VALIDATE("Currency Code", CurrencyCode);
        if Description <> '' then
            GenJnlLine.Description := Description;
        if ExtDocNo <> '' then
            GenJnlLine.Validate("External Document No.", ExtDocNo);
        if PaymentMethod <> '' then
            GenJnlLine.Validate("Payment Method Code", PaymentMethod);
        GenJnlLine."Applies-to ID" := SalesHeader."No.";
        GenJnlLine."Order No." := SalesHeader."No.";
        GenJnlLine."Advance Payment" := IsDeposit;
        GenJnlLine."Source Code" := GenJournalTemplate."Source Code";
        GenJnlLine."Reason Code" := GenJournalBatch."Reason Code";
        GenJnlLine.VALIDATE(Amount, AmountToHandle);

        //GenJnlLine.VALIDATE("Payment Method Code", 'BANK');

        GenJnlPostLine.RunWithCheck(GenJnlLine);
    end;
    //CheckTemplateName等函数从
    procedure CheckTemplateName(CurrentJnlTemplateName: Code[10]; var CurrentJnlBatchName: Code[10])
    var
        [SecurityFiltering(SecurityFilter::Filtered)]
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        GenJnlBatch.SetRange("Journal Template Name", CurrentJnlTemplateName);
        if not GenJnlBatch.Get(CurrentJnlTemplateName, CurrentJnlBatchName) then begin
            if not GenJnlBatch.FindFirst then begin
                GenJnlBatch.Init();
                GenJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
                GenJnlBatch.SetupNewBatch;
                GenJnlBatch.Name := Text004;
                GenJnlBatch.Description := Text005;
                GenJnlBatch.Insert(true);
                Commit();
            end;
            CurrentJnlBatchName := GenJnlBatch.Name
        end;
    end;

    procedure TemplateSelectionSimple(var GenJnlTemplate: Record "Gen. Journal Template"; TemplateType: Enum "Gen. Journal Template Type"; RecurringJnl: Boolean): Boolean
    begin
        GenJnlTemplate.Reset();
        GenJnlTemplate.SetRange(Type, TemplateType);
        GenJnlTemplate.SetRange(Recurring, RecurringJnl);
        exit(FindTemplateFromSelection(GenJnlTemplate, TemplateType, RecurringJnl));
    end;

    local procedure FindTemplateFromSelection(var GenJnlTemplate: Record "Gen. Journal Template"; TemplateType: Enum "Gen. Journal Template Type"; RecurringJnl: Boolean) TemplateSelected: Boolean
    begin
        TemplateSelected := true;
        case GenJnlTemplate.Count of
            0:
                begin
                    GenJnlTemplate.Init();
                    GenJnlTemplate.Type := TemplateType;
                    GenJnlTemplate.Recurring := RecurringJnl;
                    if not RecurringJnl then begin
                        GenJnlTemplate.Name :=
                          GetAvailableGeneralJournalTemplateName(Format(GenJnlTemplate.Type, MaxStrLen(GenJnlTemplate.Name)));
                        if TemplateType = GenJnlTemplate.Type::Assets then
                            GenJnlTemplate.Description := Text000
                        else
                            GenJnlTemplate.Description := StrSubstNo(Text001, GenJnlTemplate.Type);
                    end else begin
                        GenJnlTemplate.Name := Text002;
                        GenJnlTemplate.Description := Text003;
                    end;
                    GenJnlTemplate.Validate(Type);
                    GenJnlTemplate.Insert();
                    Commit();
                end;
            1:
                GenJnlTemplate.FindFirst;
            else
                TemplateSelected := PAGE.RunModal(0, GenJnlTemplate) = ACTION::LookupOK;
        end;
    end;

    procedure GetAvailableGeneralJournalTemplateName(TemplateName: Code[10]): Code[10]
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        PotentialTemplateName: Code[10];
        PotentialTemplateNameIncrement: Integer;
    begin
        if StrLen(TemplateName) > 9 then
            TemplateName := Format(TemplateName, 9);

        GenJnlTemplate.Init();
        PotentialTemplateName := TemplateName;
        PotentialTemplateNameIncrement := 0;

        while PotentialTemplateNameIncrement < 10 do begin
            GenJnlTemplate.SetFilter(Name, PotentialTemplateName);
            if GenJnlTemplate.Count = 0 then
                exit(PotentialTemplateName);

            PotentialTemplateNameIncrement := PotentialTemplateNameIncrement + 1;
            PotentialTemplateName := TemplateName + Format(PotentialTemplateNameIncrement);
        end;
    end;
    //========================================================================================================
}

