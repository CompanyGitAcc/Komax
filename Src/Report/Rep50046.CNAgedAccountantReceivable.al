report 50046 "CN Aged Accounts Receivable"
{
    DefaultLayout = RDLC;
    //++ALF
    RDLCLayout = './Layout/AgedAccountsReceivable.rdlc';
    //ProcessingOnly = true;
    //--ALF
    ApplicationArea = Basic, Suite;
    Caption = 'Aged Accounts Receivable';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;

    dataset
    {
        dataitem(Header; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(CompanyName; CompanyDisplayName)
            {
            }
            column(FormatEndingDate; StrSubstNo(Text006, Format(EndingDate, 0, 4)))
            {
            }
            column(PostingDate; StrSubstNo(Text007, SelectStr(AgingBy + 1, Text009)))
            {
            }
            column(PrintAmountInLCY; PrintAmountInLCY)
            {
            }
            column(TableCaptnCustFilter; Customer.TableCaption + ': ' + CustFilter)
            {
            }
            column(CustFilter; CustFilter)
            {
            }
            column(AgingByDueDate; AgingBy = AgingBy::"Due Date")
            {
            }
            column(AgedbyDocumnetDate; StrSubstNo(Text004, SelectStr(AgingBy + 1, Text009)))
            {
            }
            //++ALF1
            column(HeaderText6; HeaderText[6])
            {
            }
            //--ALF1
            column(HeaderText5; HeaderText[5])
            {
            }
            column(HeaderText4; HeaderText[4])
            {
            }
            column(HeaderText3; HeaderText[3])
            {
            }
            column(HeaderText2; HeaderText[2])
            {
            }
            column(HeaderText1; HeaderText[1])
            {
            }
            column(PrintDetails; PrintDetails)
            {
            }
            column(AgedAccReceivableCptn; AgedAccReceivableCptnLbl)
            {
            }
            column(CurrReportPageNoCptn; CurrReportPageNoCptnLbl)
            {
            }
            column(AllAmtinLCYCptn; AllAmtinLCYCptnLbl)
            {
            }
            column(AgedOverdueAmtCptn; AgedOverdueAmtCptnLbl)
            {
            }
            column(CLEEndDateAmtLCYCptn; CLEEndDateAmtLCYCptnLbl)
            {
            }
            column(CLEEndDateDueDateCptn; CLEEndDateDueDateCptnLbl)
            {
            }
            column(CLEEndDateDocNoCptn; CLEEndDateDocNoCptnLbl)
            {
            }
            column(CLEEndDatePstngDateCptn; CLEEndDatePstngDateCptnLbl)
            {
            }
            column(CLEEndDateDocTypeCptn; CLEEndDateDocTypeCptnLbl)
            {
            }
            column(OriginalAmtCptn; OriginalAmtCptnLbl)
            {
            }
            column(TotalLCYCptn; TotalLCYCptnLbl)
            {
            }
            column(NewPagePercustomer; NewPagePercustomer)
            {
            }
            //++ALF1
            column(GrandTotalCLE6RemAmt; GrandTotalCustLedgEntry[6]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            //--ALF1
            column(GrandTotalCLE5RemAmt; GrandTotalCustLedgEntry[5]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCLE4RemAmt; GrandTotalCustLedgEntry[4]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCLE3RemAmt; GrandTotalCustLedgEntry[3]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCLE2RemAmt; GrandTotalCustLedgEntry[2]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCLE1RemAmt; GrandTotalCustLedgEntry[1]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCLEAmtLCY; GrandTotalCustLedgEntry[1]."Amount (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCLE1CustRemAmtLCY; Pct(GrandTotalCustLedgEntry[1]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(GrandTotalCLE2CustRemAmtLCY; Pct(GrandTotalCustLedgEntry[2]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(GrandTotalCLE3CustRemAmtLCY; Pct(GrandTotalCustLedgEntry[3]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(GrandTotalCLE4CustRemAmtLCY; Pct(GrandTotalCustLedgEntry[4]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(GrandTotalCLE5CustRemAmtLCY; Pct(GrandTotalCustLedgEntry[5]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            //++ALF1
            column(GrandTotalCLE6CustRemAmtLCY; Pct(GrandTotalCustLedgEntry[6]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            //--ALF1
            column(GrandTotalCLE1AmtLCY; GrandTotalCustLedgEntry[1]."Amount (LCY)")
            {
                AutoFormatType = 1;
            }
            //++ALF1
            column(GrandTotalCLE6PctRemAmtLCY; Pct(GrandTotalCustLedgEntry[6]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(GrandTotalCLE4PctRemAmtLCY; Pct(GrandTotalCustLedgEntry[4]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            //--ALF1
            column(GrandTotalCLE5PctRemAmtLCY; Pct(GrandTotalCustLedgEntry[5]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(GrandTotalCLE3PctRemAmtLCY; Pct(GrandTotalCustLedgEntry[3]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(GrandTotalCLE2PctRemAmtLCY; Pct(GrandTotalCustLedgEntry[2]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(GrandTotalCLE1PctRemAmtLCY; Pct(GrandTotalCustLedgEntry[1]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            //++ALF1
            column(GrandTotalCLE6RemAmtLCY; GrandTotalCustLedgEntry[6]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            //--ALF1
            column(GrandTotalCLE5RemAmtLCY; GrandTotalCustLedgEntry[5]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCLE4RemAmtLCY; GrandTotalCustLedgEntry[4]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCLE3RemAmtLCY; GrandTotalCustLedgEntry[3]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCLE2RemAmtLCY; GrandTotalCustLedgEntry[2]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCLE1RemAmtLCY; GrandTotalCustLedgEntry[1]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            dataitem(Customer; Customer)
            {
                RequestFilterFields = "No.";
                column(PageGroupNo; PageGroupNo)
                {
                }
                column(CustomerPhoneNoCaption; FieldCaption("Phone No."))
                {
                }
                column(CustomerContactCaption; FieldCaption(Contact))
                {
                }
                dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = FIELD("No.");
                    DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code");

                    trigger OnAfterGetRecord()
                    var
                        CustLedgEntry: Record "Cust. Ledger Entry";
                        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                    begin
                        CustLedgEntry.SetCurrentKey("Closed by Entry No.");
                        if "Closed by Entry No." <> 0 then
                            CustLedgEntry.SetFilter("Closed by Entry No.", '%1|%2', "Entry No.", "Closed by Entry No.")
                        else
                            CustLedgEntry.SetRange("Closed by Entry No.", "Entry No.");
                        CustLedgEntry.SetRange("Posting Date", 0D, EndingDate);
                        //++ALF230219
                        if ExcludeAdvancePayment then
                            CustLedgEntry.SetRange("Advance Payment", false);
                        //--ALF230219
                        CopyDimFiltersFromCustomer(CustLedgEntry);
                        if CustLedgEntry.FindSet(false, false) then
                            repeat
                                InsertTemp(CustLedgEntry);
                            until CustLedgEntry.Next() = 0;

                        CustLedgEntry.Reset();
                        CustLedgEntry.SetRange("Entry No.", "Closed by Entry No.");
                        CustLedgEntry.SetRange("Posting Date", 0D, EndingDate);
                        //++ALF230219
                        if ExcludeAdvancePayment then
                            CustLedgEntry.SetRange("Advance Payment", false);
                        //--ALF230219
                        CopyDimFiltersFromCustomer(CustLedgEntry);
                        if CustLedgEntry.FindSet(false, false) then
                            repeat
                                InsertTemp(CustLedgEntry);
                            until CustLedgEntry.Next() = 0;
                        CurrReport.Skip();
                        //++ALF
                        // CustLedgEntry.GET("Entry No.");
                        // DtldCustLedgEntry.RESET;
                        // DtldCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
                        // DtldCustLedgEntry.SETRANGE("Entry Type", DtldCustLedgEntry."Entry Type"::Application);
                        // DtldCustLedgEntry.SETRANGE("Posting Date", EndingDate + 1, 99991231D);
                        // IF DtldCustLedgEntry.FIND('-') THEN
                        //     REPEAT
                        //         InsertTemp(CustLedgEntry);
                        //     UNTIL DtldCustLedgEntry.NEXT = 0;
                        //--
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange("Posting Date", EndingDate + 1, DMY2Date(31, 12, 9999));
                        //++ALF230219
                        if ExcludeAdvancePayment then
                            SetRange("Advance Payment", false);
                        //--ALF230219
                        CopyDimFiltersFromCustomer("Cust. Ledger Entry");
                        Customer.CopyFilter("Currency Filter", "Currency Code");
                    end;
                }
                dataitem(OpenCustLedgEntry; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = FIELD("No.");
                    DataItemTableView = SORTING("Customer No.", Open, Positive, "Due Date", "Currency Code");

                    trigger OnAfterGetRecord()
                    begin
                        InsertTemp(OpenCustLedgEntry);
                        CurrReport.Skip();
                    end;

                    trigger OnPreDataItem()
                    begin
                        if AgingBy = AgingBy::"Posting Date" then begin
                            SetRange("Posting Date", 0D, EndingDate);
                            SetRange("Date Filter", 0D, EndingDate);
                            SetAutoCalcFields("Remaining Amt. (LCY)");
                            SetFilter("Remaining Amt. (LCY)", '<>0');
                        end;
                        //++ALF230219
                        if ExcludeAdvancePayment then
                            SetRange("Advance Payment", false);
                        //--ALF230219
                        CopyDimFiltersFromCustomer(OpenCustLedgEntry);
                        Customer.CopyFilter("Currency Filter", "Currency Code");
                    end;
                }
                dataitem(CurrencyLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                    PrintOnlyIfDetail = true;
                    dataitem(TempCustLedgEntryLoop; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                        //++ALF1
                        // column(Name1_Cust; Customer.Name)
                        // {
                        //     IncludeCaption = true;
                        // }
                        column(Name1_Cust; Customer."Name 2")
                        {
                            IncludeCaption = true;
                        }
                        //--ALF1
                        column(No_Cust; Customer."No.")
                        {
                            IncludeCaption = true;
                        }
                        column(CustomerPhoneNo; Customer."Phone No.")
                        {
                        }
                        column(CustomerContactName; Customer.Contact)
                        {
                        }
                        column(CLEEndDateRemAmtLCY; CustLedgEntryEndingDate."Remaining Amt. (LCY)")
                        {
                            AutoFormatType = 1;
                        }
                        column(AgedCLE1RemAmtLCY; AgedCustLedgEntry[1]."Remaining Amt. (LCY)")
                        {
                            AutoFormatType = 1;
                        }
                        column(AgedCLE2RemAmtLCY; AgedCustLedgEntry[2]."Remaining Amt. (LCY)")
                        {
                            AutoFormatType = 1;
                        }
                        column(AgedCLE3RemAmtLCY; AgedCustLedgEntry[3]."Remaining Amt. (LCY)")
                        {
                            AutoFormatType = 1;
                        }
                        column(AgedCLE4RemAmtLCY; AgedCustLedgEntry[4]."Remaining Amt. (LCY)")
                        {
                            AutoFormatType = 1;
                        }
                        column(AgedCLE5RemAmtLCY; AgedCustLedgEntry[5]."Remaining Amt. (LCY)")
                        {
                            AutoFormatType = 1;
                        }
                        //++ALF1
                        column(AgedCLE6RemAmtLCY; AgedCustLedgEntry[6]."Remaining Amt. (LCY)")
                        {
                            AutoFormatType = 1;
                        }
                        //--ALF1
                        column(CLEEndDateAmtLCY; CustLedgEntryEndingDate."Amount (LCY)")
                        {
                            AutoFormatType = 1;
                        }
                        column(CLEEndDueDate; Format(CustLedgEntryEndingDate."Due Date"))
                        {
                        }
                        column(CLEEndDateDocNo; CustLedgEntryEndingDate."Document No.")
                        {
                        }
                        column(CLEDocType; Format(CustLedgEntryEndingDate."Document Type"))
                        {
                        }
                        column(CLEPostingDate; Format(CustLedgEntryEndingDate."Posting Date"))
                        {
                        }
                        //++ALF1
                        column(AgedCLE6TempRemAmt; AgedCustLedgEntry[6]."Remaining Amount")
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }
                        //--ALF1
                        column(AgedCLE5TempRemAmt; AgedCustLedgEntry[5]."Remaining Amount")
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(AgedCLE4TempRemAmt; AgedCustLedgEntry[4]."Remaining Amount")
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(AgedCLE3TempRemAmt; AgedCustLedgEntry[3]."Remaining Amount")
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(AgedCLE2TempRemAmt; AgedCustLedgEntry[2]."Remaining Amount")
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(AgedCLE1TempRemAmt; AgedCustLedgEntry[1]."Remaining Amount")
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(RemAmt_CLEEndDate; CustLedgEntryEndingDate."Remaining Amount")
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(CLEEndDate_ExtDocNo; CustLedgEntryEndingDate."External Document No.")
                        {

                        }
                        column(CLEEndDate; CustLedgEntryEndingDate.Amount)
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Name_Cust; StrSubstNo(Text005, Customer.Name))
                        {
                        }
                        column(TotalCLE1AmtLCY; TotalCustLedgEntry[1]."Amount (LCY)")
                        {
                            AutoFormatType = 1;
                        }
                        column(TotalCLE1RemAmtLCY; TotalCustLedgEntry[1]."Remaining Amt. (LCY)")
                        {
                            AutoFormatType = 1;
                        }
                        column(TotalCLE2RemAmtLCY; TotalCustLedgEntry[2]."Remaining Amt. (LCY)")
                        {
                            AutoFormatType = 1;
                        }
                        column(TotalCLE3RemAmtLCY; TotalCustLedgEntry[3]."Remaining Amt. (LCY)")
                        {
                            AutoFormatType = 1;
                        }
                        column(TotalCLE4RemAmtLCY; TotalCustLedgEntry[4]."Remaining Amt. (LCY)")
                        {
                            AutoFormatType = 1;
                        }
                        column(TotalCLE5RemAmtLCY; TotalCustLedgEntry[5]."Remaining Amt. (LCY)")
                        {
                            AutoFormatType = 1;
                        }
                        //++ALF1
                        column(TotalCLE6RemAmtLCY; TotalCustLedgEntry[6]."Remaining Amt. (LCY)")
                        {
                            AutoFormatType = 1;
                        }
                        //--ALF1
                        column(CurrrencyCode; CurrencyCode)
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }
                        //++ALF1
                        column(TotalCLE6RemAmt; TotalCustLedgEntry[6]."Remaining Amount")
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }
                        //--ALF1
                        column(TotalCLE5RemAmt; TotalCustLedgEntry[5]."Remaining Amount")
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalCLE4RemAmt; TotalCustLedgEntry[4]."Remaining Amount")
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalCLE3RemAmt; TotalCustLedgEntry[3]."Remaining Amount")
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalCLE2RemAmt; TotalCustLedgEntry[2]."Remaining Amount")
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalCLE1RemAmt; TotalCustLedgEntry[1]."Remaining Amount")
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalCLE1Amt; TotalCustLedgEntry[1].Amount)
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalCheck; CustFilterCheck)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            PeriodIndex: Integer;
                        begin
                            if Number = 1 then begin
                                if not TempCustLedgEntry.FindSet(false, false) then
                                    CurrReport.Break();
                            end else
                                if TempCustLedgEntry.Next() = 0 then
                                    CurrReport.Break();

                            //++ALF
                            // IF NOT showName2 THEN
                            //     CustName := Customer.Name
                            // ELSE
                            //     CustName := Customer."Name 2";
                            //--
                            CustLedgEntryEndingDate := TempCustLedgEntry;
                            DetailedCustomerLedgerEntry.SetRange("Cust. Ledger Entry No.", CustLedgEntryEndingDate."Entry No.");
                            if DetailedCustomerLedgerEntry.FindSet(false, false) then
                                repeat
                                    if (DetailedCustomerLedgerEntry."Entry Type" =
                                        DetailedCustomerLedgerEntry."Entry Type"::"Initial Entry") and
                                       (CustLedgEntryEndingDate."Posting Date" > EndingDate) and
                                       (AgingBy <> AgingBy::"Posting Date")
                                    then begin
                                        if CustLedgEntryEndingDate."Document Date" <= EndingDate then
                                            DetailedCustomerLedgerEntry."Posting Date" :=
                                              CustLedgEntryEndingDate."Document Date"
                                        else
                                            if (CustLedgEntryEndingDate."Due Date" <= EndingDate) and
                                               (AgingBy = AgingBy::"Due Date")
                                            then
                                                DetailedCustomerLedgerEntry."Posting Date" :=
                                                  CustLedgEntryEndingDate."Due Date"
                                    end;

                                    if (DetailedCustomerLedgerEntry."Posting Date" <= EndingDate) or
                                       (TempCustLedgEntry.Open and
                                        (AgingBy = AgingBy::"Due Date") and
                                        (CustLedgEntryEndingDate."Due Date" > EndingDate) and
                                        (CustLedgEntryEndingDate."Posting Date" <= EndingDate))
                                    then begin
                                        if DetailedCustomerLedgerEntry."Entry Type" in
                                           [DetailedCustomerLedgerEntry."Entry Type"::"Initial Entry",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Unrealized Loss",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Unrealized Gain",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Realized Loss",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Realized Gain",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Payment Discount",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Payment Discount (VAT Excl.)",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Payment Discount (VAT Adjustment)",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Payment Tolerance",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Payment Discount Tolerance",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Payment Tolerance (VAT Excl.)",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Payment Tolerance (VAT Adjustment)",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)"]
                                        then begin
                                            CustLedgEntryEndingDate.Amount := CustLedgEntryEndingDate.Amount + DetailedCustomerLedgerEntry.Amount;
                                            CustLedgEntryEndingDate."Amount (LCY)" :=
                                              CustLedgEntryEndingDate."Amount (LCY)" + DetailedCustomerLedgerEntry."Amount (LCY)";
                                        end;
                                        if DetailedCustomerLedgerEntry."Posting Date" <= EndingDate then begin
                                            CustLedgEntryEndingDate."Remaining Amount" :=
                                              CustLedgEntryEndingDate."Remaining Amount" + DetailedCustomerLedgerEntry.Amount;
                                            CustLedgEntryEndingDate."Remaining Amt. (LCY)" :=
                                              CustLedgEntryEndingDate."Remaining Amt. (LCY)" + DetailedCustomerLedgerEntry."Amount (LCY)";
                                        end;
                                    end;
                                until DetailedCustomerLedgerEntry.Next() = 0;

                            if CustLedgEntryEndingDate."Remaining Amount" = 0 then
                                CurrReport.Skip();

                            case AgingBy of
                                AgingBy::"Due Date":
                                    PeriodIndex := GetPeriodIndex(CustLedgEntryEndingDate."Due Date");
                                AgingBy::"Posting Date":
                                    PeriodIndex := GetPeriodIndex(CustLedgEntryEndingDate."Posting Date");
                                AgingBy::"Document Date":
                                    begin
                                        if CustLedgEntryEndingDate."Document Date" > EndingDate then begin
                                            CustLedgEntryEndingDate."Remaining Amount" := 0;
                                            CustLedgEntryEndingDate."Remaining Amt. (LCY)" := 0;
                                            CustLedgEntryEndingDate."Document Date" := CustLedgEntryEndingDate."Posting Date";
                                        end;
                                        PeriodIndex := GetPeriodIndex(CustLedgEntryEndingDate."Document Date");
                                    end;
                            end;
                            Clear(AgedCustLedgEntry);
                            AgedCustLedgEntry[PeriodIndex]."Remaining Amount" := CustLedgEntryEndingDate."Remaining Amount";
                            AgedCustLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" := CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                            TotalCustLedgEntry[PeriodIndex]."Remaining Amount" += CustLedgEntryEndingDate."Remaining Amount";
                            TotalCustLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" += CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                            GrandTotalCustLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" += CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                            TotalCustLedgEntry[1].Amount += CustLedgEntryEndingDate."Remaining Amount";
                            TotalCustLedgEntry[1]."Amount (LCY)" += CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                            GrandTotalCustLedgEntry[1]."Amount (LCY)" += CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                            NumberOfLines += 1;
                            //++ALF: export to excel - body
                            // IF ((ExportToExcel = TRUE) AND PrintAmountInLCY AND PrintDetails) THEN BEGIN
                            //     RowNo := RowNo + 1;
                            //     ;
                            //     EnterCell(RowNo, 1, FORMAT(CustLedgEntryEndingDate."Posting Date"), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 2, FORMAT(CustLedgEntryEndingDate."Document Type"), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 3, FORMAT(CustLedgEntryEndingDate."Document No."), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 4, FORMAT(CustLedgEntryEndingDate."Salesperson Code"), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 5, FORMAT(CustLedgEntryEndingDate."Due Date"), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 6, FORMAT(CustLedgEntryEndingDate."Remaining Amt. (LCY)"), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 7, FORMAT(CustLedgEntryEndingDate."Amount (LCY)"), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 8, FORMAT(AgedCustLedgEntry[1]."Remaining Amt. (LCY)"), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 9, FORMAT(AgedCustLedgEntry[2]."Remaining Amt. (LCY)"), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 10, FORMAT(AgedCustLedgEntry[3]."Remaining Amt. (LCY)"), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 11, FORMAT(AgedCustLedgEntry[4]."Remaining Amt. (LCY)"), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 12, FORMAT(AgedCustLedgEntry[5]."Remaining Amt. (LCY)"), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 13, FORMAT(AgedCustLedgEntry[6]."Remaining Amt. (LCY)"), FALSE, FALSE, FALSE);
                            // END;
                            // IF ((ExportToExcel = TRUE) AND NOT PrintAmountInLCY AND PrintDetails) THEN BEGIN
                            //     RowNo := RowNo + 1;
                            //     ;
                            //     EnterCell(RowNo, 1, FORMAT(CustLedgEntryEndingDate."Posting Date"), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 2, FORMAT(CustLedgEntryEndingDate."Document Type"), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 3, FORMAT(CustLedgEntryEndingDate."Document No."), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 4, FORMAT(CustLedgEntryEndingDate."Salesperson Code"), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 5, FORMAT(CustLedgEntryEndingDate."Due Date"), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 6, FORMAT(CustLedgEntryEndingDate."Remaining Amount"), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 7, FORMAT(CustLedgEntryEndingDate.Amount), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 8, FORMAT(AgedCustLedgEntry[1]."Remaining Amount"), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 9, FORMAT(AgedCustLedgEntry[2]."Remaining Amount"), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 10, FORMAT(AgedCustLedgEntry[3]."Remaining Amount"), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 11, FORMAT(AgedCustLedgEntry[4]."Remaining Amount"), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 12, FORMAT(AgedCustLedgEntry[5]."Remaining Amount"), FALSE, FALSE, FALSE);
                            //     EnterCell(RowNo, 13, FORMAT(AgedCustLedgEntry[6]."Remaining Amount"), FALSE, FALSE, FALSE);
                            // END;
                            //--ALF
                        end;

                        trigger OnPostDataItem()
                        begin
                            if not PrintAmountInLCY then
                                UpdateCurrencyTotals;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not PrintAmountInLCY then begin
                                if (TempCurrency.Code = '') or (TempCurrency.Code = GLSetup."LCY Code") then
                                    TempCustLedgEntry.SetFilter("Currency Code", '%1|%2', GLSetup."LCY Code", '')
                                else
                                    TempCustLedgEntry.SetRange("Currency Code", TempCurrency.Code);
                            end;

                            PageGroupNo := NextPageGroupNo;
                            if NewPagePercustomer and (NumberOfCurrencies > 0) then
                                NextPageGroupNo := PageGroupNo + 1;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        Clear(TotalCustLedgEntry);

                        if Number = 1 then begin
                            if not TempCurrency.FindSet(false, false) then begin
                                CurrReport.Break();
                                NumberOfLines -= 1;
                            end;
                        end else
                            if TempCurrency.Next() = 0 then begin
                                CurrReport.Break();
                                NumberOfLines -= 1;
                            end;

                        if TempCurrency.Code <> '' then
                            CurrencyCode := TempCurrency.Code
                        else
                            CurrencyCode := GLSetup."LCY Code";

                        NumberOfCurrencies := NumberOfCurrencies + 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        NumberOfCurrencies := 0;
                    end;
                }

                //++ALF
                // trigger OnPreDataItem()
                // begin
                //     window.OPEN('Calculating Customer:#1######');
                //     RowNo := 3;
                //     RowNo := RowNo + 1;
                //     EnterCell(RowNo, 1, 'All Amounts in LCY', TRUE, FALSE, FALSE);
                //     RowNo := RowNo + 1;

                //     IF (ExportToExcel = TRUE) AND (PrintDetails) THEN BEGIN
                //         RowNo := RowNo + 1;
                //         ;
                //         EnterCell(RowNo, 1, 'Posting Date', FALSE, FALSE, FALSE);
                //         EnterCell(RowNo, 2, 'Document type', FALSE, FALSE, FALSE);
                //         EnterCell(RowNo, 3, 'Document No', FALSE, FALSE, FALSE);
                //         EnterCell(RowNo, 4, 'Salesperson Code', FALSE, FALSE, FALSE);
                //         EnterCell(RowNo, 5, 'Due Date', FALSE, FALSE, FALSE);
                //         EnterCell(RowNo, 6, 'Original Amount', FALSE, FALSE, FALSE);
                //         EnterCell(RowNo, 7, 'Balance', FALSE, FALSE, FALSE);
                //         EnterCell(RowNo, 8, FORMAT(HeaderText[1]), FALSE, FALSE, FALSE);
                //         EnterCell(RowNo, 9, FORMAT(HeaderText[2]), FALSE, FALSE, FALSE);
                //         EnterCell(RowNo, 10, FORMAT(HeaderText[3]), FALSE, FALSE, FALSE);
                //         EnterCell(RowNo, 11, FORMAT(HeaderText[4]), FALSE, FALSE, FALSE);
                //         EnterCell(RowNo, 12, FORMAT(HeaderText[5]), FALSE, FALSE, FALSE);
                //         EnterCell(RowNo, 13, FORMAT(HeaderText[6]), FALSE, FALSE, FALSE);
                //     END;
                // end;
                //--ALF
                trigger OnAfterGetRecord()
                begin
                    if NewPagePercustomer then
                        PageGroupNo += 1;
                    TempCurrency.Reset();
                    TempCurrency.DeleteAll();
                    TempCustLedgEntry.Reset();
                    TempCustLedgEntry.DeleteAll();
                    NumberOfLines += 1;
                    //++ALF
                    // window.UPDATE(1, "No.");
                    // if ExportToExcel then begin
                    //     RowNo := RowNo + 1;
                    //     ;
                    //     EnterCell(RowNo, 1, FORMAT(Customer."No."), FALSE, FALSE, FALSE);
                    //     EnterCell(RowNo, 2, FORMAT(CustName), FALSE, FALSE, FALSE);
                    // end;
                    //--ALF
                end;
            }
            dataitem(CurrencyTotals; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                column(CurrNo; Number = 1)
                {
                }
                column(TempCurrCode; TempCurrency2.Code)
                {
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                }
                column(AgedCLE6RemAmt; AgedCustLedgEntry[6]."Remaining Amount")
                {
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                }
                column(AgedCLE1RemAmt; AgedCustLedgEntry[1]."Remaining Amount")
                {
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                }
                column(AgedCLE2RemAmt; AgedCustLedgEntry[2]."Remaining Amount")
                {
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                }
                column(AgedCLE3RemAmt; AgedCustLedgEntry[3]."Remaining Amount")
                {
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                }
                column(AgedCLE4RemAmt; AgedCustLedgEntry[4]."Remaining Amount")
                {
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                }
                column(AgedCLE5RemAmt; AgedCustLedgEntry[5]."Remaining Amount")
                {
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                }
                column(CurrSpecificationCptn; CurrSpecificationCptnLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then begin
                        if not TempCurrency2.FindSet(false, false) then
                            CurrReport.Break();
                    end else
                        if TempCurrency2.Next() = 0 then
                            CurrReport.Break();

                    Clear(AgedCustLedgEntry);
                    TempCurrencyAmount.SetRange("Currency Code", TempCurrency2.Code);
                    if TempCurrencyAmount.FindSet(false, false) then
                        repeat
                            if TempCurrencyAmount.Date <> DMY2Date(31, 12, 9999) then
                                AgedCustLedgEntry[GetPeriodIndex(TempCurrencyAmount.Date)]."Remaining Amount" :=
                                  TempCurrencyAmount.Amount
                            else
                                AgedCustLedgEntry[6]."Remaining Amount" := TempCurrencyAmount.Amount;
                        until TempCurrencyAmount.Next() = 0;
                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(AgedAsOf; EndingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aged As Of';
                        ToolTip = 'Specifies the date that you want the aging calculated for.';
                    }
                    field(Agingby; AgingBy)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aging by';
                        OptionCaption = 'Due Date,Posting Date,Document Date';
                        ToolTip = 'Specifies if the aging will be calculated from the due date, the posting date, or the document date.';
                    }
                    field(PeriodLength; PeriodLength)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period Length';
                        ToolTip = 'Specifies the period for which data is shown in the report. For example, enter "1M" for one month, "30D" for thirty days, "3Q" for three quarters, or "5Y" for five years.';
                    }
                    field(AmountsinLCY; PrintAmountInLCY)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Amounts in LCY';
                        ToolTip = 'Specifies if you want the report to specify the aging per customer ledger entry.';
                    }
                    field(PrintDetails; PrintDetails)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Details';
                        ToolTip = 'Specifies if you want the report to show the detailed entries that add up the total balance for each customer.';
                    }
                    field(HeadingType; HeadingType)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Heading Type';
                        OptionCaption = 'Date Interval,Number of Days';
                        ToolTip = 'Specifies if the column heading for the three periods will indicate a date interval or the number of days overdue.';
                    }
                    field(perCustomer; NewPagePercustomer)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Page per Customer';
                        ToolTip = 'Specifies if each customer''s information is printed on a new page if you have chosen two or more customers to be included in the report.';
                    }
                    field(ExcludeAdvancePayment; ExcludeAdvancePayment)
                    {
                        Caption = 'Exclude Advance Payment';
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if EndingDate = 0D then
                EndingDate := WorkDate;
            if Format(PeriodLength) = '' then
                Evaluate(PeriodLength, '<1M>');
        end;
    }

    labels
    {
        BalanceCaption = 'Balance';
    }

    trigger OnPreReport()
    var
        FormatDocument: Codeunit "Format Document";
        RowNo: Integer;
    begin
        StartDateTime := CurrentDateTime();
        CustFilter := FormatDocument.GetRecordFiltersWithCaptions(Customer);

        GLSetup.Get();

        CalcDates;
        CreateHeadings;

        PageGroupNo := 1;
        NextPageGroupNo := 1;
        CustFilterCheck := (CustFilter <> 'No.');

        CompanyDisplayName := COMPANYPROPERTY.DisplayName;
        //++ALF
        // ExportToExcel := true;
        // ShowName2 := true;
        // IF ExportToExcel = TRUE THEN BEGIN
        //     TempExcelBuffer.RESET;
        //     TempExcelBuffer.DELETEALL;
        // END;
        // IF ExportToExcel = TRUE THEN BEGIN
        //     RowNo := RowNo + 1;
        //     EnterCell(RowNo, 1, 'Aged Accounts Receivable', TRUE, FALSE, FALSE);
        //     RowNo := RowNo + 1;
        //     EnterCell(RowNo, 1, FORMAT(COMPANYNAME), TRUE, FALSE, FALSE);
        // END;
        //--ALF
    end;

    trigger OnPostReport()
    begin
        FinishDateTime := CurrentDateTime();
        LogReportTelemetry(StartDateTime, FinishDateTime, NumberOfLines);
        //++ALF
        // IF ExportToExcel = TRUE THEN BEGIN
        //     TempExcelBuffer.CreateNewBook('Aged Accounts Receivable');
        //     FillExcelBuffer(TempExcelBuf);
        //     TempExcelBuffer.WriteSheet('Aged Accounts Receivable', CompanyName(), UserId());
        //     TempExcelBuffer.CloseBook();
        //     TempExcelBuffer.SetFriendlyFilename('Aged Accounts Receivable');
        //     TempExcelBuffer.OpenExcel();
        // END;
        //--ALF
    end;

    local procedure CalcDates()
    var
        i: Integer;
        PeriodLength2: DateFormula;
    begin
        if not Evaluate(PeriodLength2, StrSubstNo(Text032Txt, PeriodLength)) then
            Error(EnterDateFormulaErr);
        if AgingBy = AgingBy::"Due Date" then begin
            PeriodEndDate[1] := DMY2Date(31, 12, 9999);
            PeriodStartDate[1] := EndingDate + 1;
        end else begin
            PeriodEndDate[1] := EndingDate;
            PeriodStartDate[1] := CalcDate(PeriodLength2, EndingDate + 1);
        end;
        for i := 2 to ArrayLen(PeriodEndDate) do begin
            PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
            PeriodStartDate[i] := CalcDate(PeriodLength2, PeriodEndDate[i] + 1);
        end;
        PeriodStartDate[i] := 0D;

        for i := 1 to ArrayLen(PeriodEndDate) do
            if PeriodEndDate[i] < PeriodStartDate[i] then
                Error(Text010, PeriodLength);
    end;

    local procedure CreateHeadings()
    var
        i: Integer;
    begin
        if AgingBy = AgingBy::"Due Date" then begin
            HeaderText[1] := Text000;
            i := 2;
        end else
            i := 1;
        while i < ArrayLen(PeriodEndDate) do begin
            if HeadingType = HeadingType::"Date Interval" then
                HeaderText[i] := StrSubstNo('%1\..%2', PeriodStartDate[i], PeriodEndDate[i])
            else
                HeaderText[i] :=
                  StrSubstNo('%1 - %2 %3', EndingDate - PeriodEndDate[i] + 1, EndingDate - PeriodStartDate[i] + 1, Text002);
            i := i + 1;
        end;
        if HeadingType = HeadingType::"Date Interval" then
            HeaderText[i] := StrSubstNo('%1 %2', BeforeTok, PeriodStartDate[i - 1])
        else
            HeaderText[i] := StrSubstNo('%1 %2 %3', BeforeTok, EndingDate - PeriodStartDate[i - 1] + 1, Text002);
    end;

    local procedure InsertTemp(var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        Currency: Record Currency;
    begin
        with TempCustLedgEntry do begin
            if Get(CustLedgEntry."Entry No.") then
                exit;
            TempCustLedgEntry := CustLedgEntry;
            Insert;
            if PrintAmountInLCY then begin
                Clear(TempCurrency);
                TempCurrency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
                if TempCurrency.Insert() then;
                exit;
            end;
            if TempCurrency.Get("Currency Code") then
                exit;
            if TempCurrency.Get('') and ("Currency Code" = GLSetup."LCY Code") then
                exit;
            if TempCurrency.Get(GLSetup."LCY Code") and ("Currency Code" = '') then
                exit;
            if "Currency Code" <> '' then
                Currency.Get("Currency Code")
            else begin
                Clear(Currency);
                Currency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
            end;
            TempCurrency := Currency;
            TempCurrency.Insert();
        end;
    end;

    local procedure GetPeriodIndex(Date: Date): Integer
    var
        i: Integer;
    begin
        for i := 1 to ArrayLen(PeriodEndDate) do
            if Date in [PeriodStartDate[i] .. PeriodEndDate[i]] then
                exit(i);
    end;

    local procedure Pct(a: Decimal; b: Decimal): Text[30]
    begin
        if b <> 0 then
            exit(Format(Round(100 * a / b, 0.1), 0, '<Sign><Integer><Decimals,2>') + '%');
    end;

    local procedure UpdateCurrencyTotals()
    var
        i: Integer;
    begin
        TempCurrency2.Code := CurrencyCode;
        if TempCurrency2.Insert() then;
        with TempCurrencyAmount do begin
            for i := 1 to ArrayLen(TotalCustLedgEntry) do begin
                "Currency Code" := CurrencyCode;
                Date := PeriodStartDate[i];
                if Find then begin
                    Amount := Amount + TotalCustLedgEntry[i]."Remaining Amount";
                    Modify;
                end else begin
                    "Currency Code" := CurrencyCode;
                    Date := PeriodStartDate[i];
                    Amount := TotalCustLedgEntry[i]."Remaining Amount";
                    Insert;
                end;
            end;
            "Currency Code" := CurrencyCode;
            Date := DMY2Date(31, 12, 9999);
            if Find then begin
                Amount := Amount + TotalCustLedgEntry[1].Amount;
                Modify;
            end else begin
                "Currency Code" := CurrencyCode;
                Date := DMY2Date(31, 12, 9999);
                Amount := TotalCustLedgEntry[1].Amount;
                Insert;
            end;
        end;
    end;

    procedure InitializeRequest(NewEndingDate: Date; NewAgingBy: Option; NewPeriodLength: DateFormula; NewPrintAmountInLCY: Boolean; NewPrintDetails: Boolean; NewHeadingType: Option; NewPagePercust: Boolean)
    begin
        EndingDate := NewEndingDate;
        AgingBy := NewAgingBy;
        PeriodLength := NewPeriodLength;
        PrintAmountInLCY := NewPrintAmountInLCY;
        PrintDetails := NewPrintDetails;
        HeadingType := NewHeadingType;
        NewPagePercustomer := NewPagePercust;
    end;

    local procedure CopyDimFiltersFromCustomer(var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        if Customer.GetFilter("Global Dimension 1 Filter") <> '' then
            CustLedgerEntry.SetFilter("Global Dimension 1 Code", Customer.GetFilter("Global Dimension 1 Filter"));
        if Customer.GetFilter("Global Dimension 2 Filter") <> '' then
            CustLedgerEntry.SetFilter("Global Dimension 2 Code", Customer.GetFilter("Global Dimension 2 Filter"));
    end;

    local procedure LogReportTelemetry(StartDateTime: DateTime; FinishDateTime: DateTime; NumberOfLines: Integer)
    var
        Dimensions: Dictionary of [Text, Text];
        ReportDuration: BigInteger;
    begin
        ReportDuration := FinishDateTime - StartDateTime;
        Dimensions.Add('Category', TelemetryCategoryTxt);
        Dimensions.Add('ReportStartTime', Format(StartDateTime, 0, 9));
        Dimensions.Add('ReportFinishTime', Format(FinishDateTime, 0, 9));
        Dimensions.Add('ReportDuration', Format(ReportDuration));
        Dimensions.Add('NumberOfLines', Format(NumberOfLines));
        Session.LogMessage('0000FJM', AgedARReportGeneratedTxt, Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, Dimensions);
    end;

    //++ALF
    // PROCEDURE EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; Bold: Boolean; Italic: Boolean; UnderLine: Boolean);
    // BEGIN
    //     TempExcelBuffer.INIT;
    //     TempExcelBuffer.VALIDATE("Row No.", RowNo);
    //     TempExcelBuffer.VALIDATE("Column No.", ColumnNo);
    //     TempExcelBuffer."Cell Value as Text" := CellValue;
    //     TempExcelBuffer.Formula := '';
    //     TempExcelBuffer.Bold := Bold;
    //     TempExcelBuffer.Italic := Italic;
    //     TempExcelBuffer.Underline := UnderLine;
    //     TempExcelBuffer.INSERT;
    // END;
    //--ALF
    var
        //++ALF
        // TempExcelBuffer: Record "Excel Buffer" temporary;
        // ExportToExcel: Boolean;
        // Window: Dialog;
        // RowNo: Integer;
        // CustName: Text[100];
        // ShowName2: Boolean;
        //--ALF
        GLSetup: Record "General Ledger Setup";
        CustLedgEntryEndingDate: Record "Cust. Ledger Entry";
        //++ALF1
        // TotalCustLedgEntry: array[5] of Record "Cust. Ledger Entry";
        // GrandTotalCustLedgEntry: array[5] of Record "Cust. Ledger Entry";
        // AgedCustLedgEntry: array[6] of Record "Cust. Ledger Entry";
        TotalCustLedgEntry: array[6] of Record "Cust. Ledger Entry";
        GrandTotalCustLedgEntry: array[6] of Record "Cust. Ledger Entry";
        AgedCustLedgEntry: array[7] of Record "Cust. Ledger Entry";
        //--ALF1
        //++ALF230219
        ExcludeAdvancePayment: Boolean;
        //--ALF230219
        TempCurrency: Record Currency temporary;
        TempCurrency2: Record Currency temporary;
        TempCurrencyAmount: Record "Currency Amount" temporary;
        DetailedCustomerLedgerEntry: Record "Detailed Cust. Ledg. Entry";
        CustFilter: Text;
        PrintAmountInLCY: Boolean;
        EndingDate: Date;
        AgingBy: Option "Due Date","Posting Date","Document Date";
        PeriodLength: DateFormula;
        PrintDetails: Boolean;
        HeadingType: Option "Date Interval","Number of Days";
        NewPagePercustomer: Boolean;
        //++ALF1
        // PeriodStartDate: array[5] of Date;
        // PeriodEndDate: array[5] of Date;
        // HeaderText: array[5] of Text[30];
        PeriodStartDate: array[6] of Date;
        PeriodEndDate: array[6] of Date;
        HeaderText: array[6] of Text[30];
        //--ALF1
        Text000: Label 'Not Due';
        BeforeTok: Label 'Before';
        CurrencyCode: Code[10];
        Text002: Label 'days';
        Text004: Label 'Aged by %1';
        Text005: Label 'Total for %1';
        Text006: Label 'Aged as of %1';
        Text007: Label 'Aged by %1';
        NumberOfCurrencies: Integer;
        Text009: Label 'Due Date,Posting Date,Document Date';
        Text010: Label 'The Date Formula %1 cannot be used. Try to restate it. E.g. 1M+CM instead of CM+1M.';
        PageGroupNo: Integer;
        NextPageGroupNo: Integer;
        CustFilterCheck: Boolean;
        Text032Txt: Label '-%1', Comment = 'Negating the period length: %1 is the period length';
        AgedAccReceivableCptnLbl: Label 'Aged Accounts Receivable';
        CurrReportPageNoCptnLbl: Label 'Page';
        AllAmtinLCYCptnLbl: Label 'All Amounts in LCY';
        AgedOverdueAmtCptnLbl: Label 'Aged Overdue Amounts';
        CLEEndDateAmtLCYCptnLbl: Label 'Original Amount ';
        CLEEndDateDueDateCptnLbl: Label 'Due Date';
        CLEEndDateDocNoCptnLbl: Label 'Document No.';
        CLEEndDatePstngDateCptnLbl: Label 'Posting Date';
        CLEEndDateDocTypeCptnLbl: Label 'Document Type';
        OriginalAmtCptnLbl: Label 'Currency Code';
        TotalLCYCptnLbl: Label 'Total (LCY)';
        CurrSpecificationCptnLbl: Label 'Currency Specification';
        EnterDateFormulaErr: Label 'Enter a date formula in the Period Length field.';
        CompanyDisplayName: Text;
        TelemetryCategoryTxt: Label 'Report', Locked = true;
        AgedARReportGeneratedTxt: Label 'Aged AR Report generated.', Locked = true;

    protected var
        TempCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        NumberOfLines: Integer;
        StartDateTime: DateTime;
        FinishDateTime: DateTime;
}

