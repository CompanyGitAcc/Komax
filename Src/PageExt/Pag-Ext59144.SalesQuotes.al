pageextension 59144 "TP Sales Quotes" extends "Sales Quotes"
{
    layout
    {
        modify("Salesperson Code")
        {
            Visible = true;
        }
        modify("Document Date")
        {
            Visible = true;
        }
        movefirst(Control1; "No.", "Sell-to Customer No.", "Sell-to Customer Name", "Salesperson Code", "External Document No.", "Location Code", "Assigned User ID", Amount, "Document Date")
        addafter("Sell-to Customer Name")
        {
            field("Sell-to Customer Name 2"; Rec."Sell-to Customer Name 2")
            {
                ApplicationArea = all;
            }
        }
        modify("Sell-to Contact")
        {
            Visible = false;
        }
        modify("Posting Date")
        {
            Visible = false;
        }
        modify("Due Date")
        {
            Visible = false;
        }
        modify("Requested Delivery Date")
        {
            Visible = false;
        }
        modify("Quote Valid Until Date")
        {
            Visible = false;
        }
    }

    actions
    {
        addafter(Print)
        {
            action("Print Sales Quote In English")
            {
                Caption = 'Print Sales Quote In English';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category6;

                trigger OnAction()
                var
                    ENSalesQuote: Report "EN Sales Quote";
                    SalesHeader: Record "Sales Header";
                    SalesHeader2: Record "Sales Header";
                    DocFilter: Text;
                begin
                    // Currpage.setselectionfilter(Salesheader);
                    // SalesHeader.SetRange("No.", Rec."No.");
                    // ENSalesQuote.Settableview(Salesheader);
                    // ENSalesQuote.Runmodal();

                    SalesHeader.Reset();
                    CurrPage.SetSelectionFilter(SalesHeader);
                    if SalesHeader.FindFirst() then
                        repeat
                            if DocFilter = '' then
                                DocFilter := SalesHeader."No."
                            else
                                DocFilter := DocFilter + '|' + SalesHeader."No.";
                        until SalesHeader.Next() = 0;
                    SalesHeader2.Reset();
                    SalesHeader2.setrange("Document Type", Rec."Document Type");
                    SalesHeader2.SetFilter("No.", DocFilter);
                    ENSalesQuote.SetTableView(SalesHeader2);
                    ENSalesQuote.RunModal();
                end;
            }
            action("Print Sales Quote In Chinese")
            {
                Caption = 'Print Sales Quote In Chinese';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category6;

                trigger OnAction()
                var
                    CNSalesQuote: Report "CN Sales Quote";
                    SalesHeader: Record "Sales Header";
                    SalesHeader2: Record "Sales Header";
                    DocFilter: Text;
                begin
                    // Currpage.setselectionfilter(Salesheader);
                    // SalesHeader.SetRange("No.", Rec."No.");
                    // CNSalesQuote.Settableview(Salesheader);
                    // CNSalesQuote.Runmodal();

                    SalesHeader.Reset();
                    CurrPage.SetSelectionFilter(SalesHeader);
                    if SalesHeader.FindFirst() then
                        repeat
                            if DocFilter = '' then
                                DocFilter := SalesHeader."No."
                            else
                                DocFilter := DocFilter + '|' + SalesHeader."No.";
                        until SalesHeader.Next() = 0;
                    SalesHeader2.Reset();
                    SalesHeader2.setrange("Document Type", Rec."Document Type");
                    SalesHeader2.SetFilter("No.", DocFilter);
                    CNSalesQuote.SetTableView(SalesHeader2);
                    CNSalesQuote.RunModal();
                end;
            }


        }

        addlast(processing)
        {
            action("Temp out  Sales Quote")
            {
                Caption = 'Temp out  Sales Quote';
                Image = Text;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Temp out  Sales Quote";

            }
        }


    }


}
