page 50099 "Earning Report Check"
{
    Caption = 'Earning Report Check';
    PageType = List;
    SourceTable = "Cust. Ledger Entry";
    SourceTableView = where("Document Type" = filter(Invoice | "Credit Memo"));
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = all; }
                field("Document No."; Rec."Document No.") { ApplicationArea = all; }
                field("Customer No."; Rec."Customer No.") { ApplicationArea = all; }
                field(Amount; Rec.Amount) { ApplicationArea = all; }
                field("Amount (LCY)"; Rec."Amount (LCY)") { ApplicationArea = all; }
                field("Sales (LCY)"; Rec."Sales (LCY)") { ApplicationArea = all; }
                field(CalcedSalesAmount; CalcedSalesAmount) { ApplicationArea = all; }
                field(GLSalesAmount; GLSalesAmount) { ApplicationArea = all; }
                field(InvLineSum; InvLineSum) { ApplicationArea = all; }
                field(CalcedCost; CalcedCost) { ApplicationArea = all; }
                field(GLCost; GLCost) { ApplicationArea = all; }
                field(CalcedDisc; CalcedDisc) { ApplicationArea = all; }
                field(GLDisc; GLDisc) { ApplicationArea = all; }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        ValueEntry: Record "Value Entry";
        GLEntry: Record "G/L Entry";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrLine: Record "Sales Cr.Memo Line";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        CalcedSalesAmount := 0;
        CalcedCost := 0;
        GLSalesAmount := 0;
        GLCost := 0;
        InvLineSum := 0;

        ValueEntry.Reset();
        ValueEntry.SetRange("Document No.", Rec."Document No.");
        if ValueEntry.FindFirst() then
            repeat
                if ValueEntry.Adjustment = false then begin
                    if IsAdjusted(ValueEntry) then
                        CalcedSalesAmount := CalcedSalesAmount + AdjustSalesAmount(ValueEntry)
                    else
                        CalcedSalesAmount := CalcedSalesAmount + ValueEntry."Sales Amount (Actual)";
                end;
                CalcedCost := CalcedCost - ValueEntry."Cost Amount (Actual)";
            until ValueEntry.Next() = 0;
        GLEntry.Reset();
        GLEntry.setrange("Document No.", Rec."Document No.");
        GLEntry.setfilter("G/L Account No.", '5101*');
        IF GLEntry.FindFirst() then
            repeat
                GLSalesAmount := GLSalesAmount - GLEntry.Amount;
            until GLEntry.Next() = 0;
        GLentry.Reset();
        GLEntry.setrange("Document No.", Rec."Document No.");
        GLEntry.setfilter("G/L Account No.", '5401*');
        IF GLEntry.FindFirst() then
            repeat
                GLCost := GLCost + GLEntry.Amount;
            until GLEntry.Next() = 0;
        InvLineSum := GetInvLineSum(Rec."Document No.");

        //calc discount
        CalcedDisc := 0;
        GLDisc := 0;
        SalesInvLine.Reset();
        SalesInvLine.SetRange("Document No.", Rec."Document No.");
        SalesInvLine.SetFilter("Line Discount Amount", '<>0');
        if SalesInvLine.FindFirst() then
            repeat
                if SalesCrMemoHeader.get(SalesInvLine."Document No.") then begin
                    if SalesCrMemoHeader."Currency Factor" = 0 then
                        SalesCrMemoHeader."Currency Factor" := 1;
                    if SalesCrMemoHeader."Prices Including VAT" = true then
                        CalcedDisc := CalcedDisc + SalesInvLine."Line Discount Amount" / SalesCrMemoHeader."Currency Factor" / ((100 + SalesInvLine."VAT %") / 100)
                    else
                        CalcedDisc := CalcedDisc + SalesInvLine."Line Discount Amount" / SalesCrMemoHeader."Currency Factor";
                end;
            until SalesInvLine.Next() = 0;

        SalesCrLine.Reset();
        SalesCrLine.SetRange("Document No.", Rec."Document No.");
        SalesCrLine.SetFilter("Line Discount Amount", '<>0');
        if SalesCrLine.FindFirst() then
            repeat
                if SalesInvHeader.get(SalesInvLine."Document No.") then begin
                    if SalesInvHeader."Currency Factor" = 0 then
                        SalesInvHeader."Currency Factor" := 1;
                    if SalesInvHeader."Prices Including VAT" = true then
                        CalcedDisc := CalcedDisc + SalesInvLine."Line Discount Amount" / SalesInvHeader."Currency Factor" / ((100 + SalesInvLine."VAT %") / 100)
                    else
                        CalcedDisc := CalcedDisc + SalesInvLine."Line Discount Amount" / SalesInvHeader."Currency Factor";
                end;
            until SalesCrLine.Next() = 0;

        GLentry.Reset();
        GLEntry.setrange("Document No.", Rec."Document No.");
        GLEntry.setfilter("G/L Account No.", '5101030301');
        IF GLEntry.FindFirst() then
            repeat
                GLDisc := GLDisc + GLEntry.Amount;
            until GLEntry.Next() = 0;
    end;

    procedure GetInvLineSum(DocNo: Code[20]): Decimal
    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        Result: Decimal;
    begin
        Result := 0;
        if SalesInvHeader.get(DocNo) then begin
            if SalesInvHeader."Currency Factor" = 0 then
                SalesInvHeader."Currency Factor" := 1;
            SalesInvLine.Reset();
            SalesInvLine.SetRange("Document No.", DocNo);
            if SalesInvLine.FindFirst() then
                repeat
                    Result := Result + SalesInvLine."Amount" / SalesInvHeader."Currency Factor";
                until SalesInvLine.Next() = 0;
            exit(Result);
        end;

        if SalesCrMemoHeader.get(DocNo) then begin
            if SalesCrMemoHeader."Currency Factor" = 0 then
                SalesCrMemoHeader."Currency Factor" := 1;
            SalesCrMemoLine.Reset();
            SalesCrMemoLine.SetRange("Document No.", DocNo);
            if SalesCrMemoLine.FindFirst() then
                repeat
                    Result := Result - SalesCrMemoLine."Amount" / SalesCrMemoHeader."Currency Factor";
                until SalesCrMemoLine.Next() = 0;
            exit(Result);
        end;
    end;

    procedure IsAdjusted(ValueEntry: Record "Value Entry"): Boolean
    var
        ValueEntry2: Record "Value Entry";
    begin
        ValueEntry2.Reset();
        ValueEntry2.SetRange("Applies-to Entry", ValueEntry."Entry No.");
        if ValueEntry2.FindFirst() then
            exit(true)
        else
            exit(false);
    end;

    procedure AdjustSalesAmount(ValueEntry: Record "Value Entry"): Decimal
    var
        ValueEntry2: Record "Value Entry";
        AdjAmt: Decimal;
    begin
        if ValueEntry."Document No." in ['SPI-23000023', 'SPI-23000038', 'SPI-23000057', 'SPI-23000091', 'SPI-23000100', 'SPI-23000103', 'SPI-23000111', 'SPI-23000113', 'SPI-23000114', 'SPI-23000139', 'SPI-23000163', 'SPI-23000166', 'SPI-23000197', 'SPI-23000230', 'SPI-23000251', 'SPI-23000253', 'SPI-23000257', 'SPI-23000262', 'SPI-23000265', 'SPI-23000267', 'SPI-23000005', 'SPI-23000009'] then begin
            AdjAmt := 0;
            ValueEntry2.Reset();
            ValueEntry2.SetRange("Applies-to Entry", ValueEntry."Entry No.");
            if ValueEntry2.FindFirst() then
                repeat
                    AdjAmt := AdjAmt + ValueEntry2."Sales Amount (Actual)";
                until ValueEntry2.Next() = 0;
            exit(ValueEntry."Sales Amount (Actual)" - AdjAmt);
        end else
            exit(ValueEntry."Sales Amount (Actual)");

    end;

    var
        CalcedSalesAmount: Decimal;
        CalcedCost: Decimal;
        GLSalesAmount: Decimal;
        GLCost: Decimal;
        CalcedDisc: Decimal;
        GLDisc: Decimal;
        InvLineSum: Decimal;
}
