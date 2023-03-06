pageextension 59006 "TP Warehouse Setup" extends "Warehouse Setup"
{
    layout
    {
        addafter(Numbering)
        {
            group(Addon)
            {
                Caption = 'Addon';
                field("Delete Partial Whse. Rcpt."; Rec."Delete Partial Whse. Rcpt.")
                {
                    ApplicationArea = all;
                }
                field("Delete Partial Whse. Shpt."; Rec."Delete Partial Whse. Shpt.")
                {
                    ApplicationArea = all;
                }

            }
        }
    }
}
