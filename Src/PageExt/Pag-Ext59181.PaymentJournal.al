pageextension 59181 "TP Payment Journal" extends "Payment Journal"
{
    layout
    {
        addafter("Account No.")
        {
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = all;
            }
            // field("Customer Name"; Rec."Customer Name")
            // {
            //     ApplicationArea = all;
            // }
        }
    }

    actions
    {
        addafter("Post and &Print")
        {
            action("Preview Check")
            {
                Caption = 'Preview Check';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category8;

                trigger OnAction()
                var
                    PaymentJournal: Report "Payment Journal";
                    GenJournalLine: Record "Gen. Journal Line";
                begin
                    GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    PaymentJournal.SetTableView(GenJournalLine);
                    PaymentJournal.RunModal();
                end;
            }
        }
    }



}
