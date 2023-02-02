pageextension 59008 "TP GL Setup" extends "General Ledger Setup"
{
    layout
    {
        addlast(General)
        {
            //==============================================================================
            //++NAV2009  说明：以下字段是从老系统迁移过来的字段，部分不再使用的字段已注释掉
            //==============================================================================               
            // field("Golden Tax - Issuer"; Rec."Golden Tax - Issuer")
            // {
            //     ApplicationArea = all;
            // }
            // field("Golden Tax - Checked by"; Rec."Golden Tax - Checked by")
            // {
            //     ApplicationArea = all;
            // }
            // field("Hide Blocked COA"; Rec."Hide Blocked COA")
            // {
            //     ApplicationArea = all;
            // }
        }
    }
}
