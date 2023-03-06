tableextension 59005 "TP Warehouse Setup" extends "Warehouse Setup"
{
    fields
    {
        //++BC190.HH
        field(59000; "Delete Partial Whse. Rcpt."; Boolean)
        {
            Caption = 'Delete Partial Whse. Rcpt.';
        }
        field(59001; "Delete Partial Whse. Shpt."; Boolean)
        {
            Caption = 'Delete Partial Whse. Shpt.';
        }
        //--BC190.HH
    }
}
