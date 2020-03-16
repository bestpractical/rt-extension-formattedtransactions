use strict;
use warnings;
package RT::Extension::FormattedTransactions;

RT->AddJavaScript('rt-extension-formattedtransactions.js');
RT->AddStyleSheets('rt-extension-formattedtransactions.css');

our $VERSION = '0.01';

{
    use RT::Transaction;
    my $orig_cf_desc = $RT::Transaction::_BriefDescriptions{CustomField};
    $RT::Transaction::_BriefDescriptions{CustomField} = sub {
        my $self = shift;

        my $field = $self->loc('CustomField');
        my $cf;
        if ( $self->Field ) {
            $cf = RT::CustomField->new( $self->CurrentUser );
            $cf->SetContextObject( $self->Object );
            $cf->Load( $self->Field );
            $field = $cf->Name();
            $field = $self->loc('a custom field') if !defined($field);
        }

        my $new = $self->NewValue;
        my $old = $self->OldValue;

        if ( $cf && $cf->Type =~ /text/i ) {
            if ( !defined($old) || $old eq '' ) {
                return ( "[_1] added", $field );    #loc()
            }
            if ( !defined($new) || $new eq '' ) {
                return ( "[_1] deleted", $field );    #loc()
            }
            else {
                return ( "[_1] changed", $field );    #loc()
            }
        }
        return $orig_cf_desc->( $self, @_ );
    };
}

{
    use RT::Interface::Web;
    push @HTML::Mason::Commands::SCRUBBER_ALLOWED_TAGS, 'INS';
}

=head1 NAME

RT-Extension-FormattedTransactions - More friendly transaction UI

=head1 DESCRIPTION

This extension tweaks transaction UI to make changes more clear and
friendly.

Currently it tweaks text custom field changes, to show old value, new value
and even also highlighted diff in separate and formatted rows.

=head1 RT VERSION

Works with RT 4.4

=head1 INSTALLATION

=over

=item C<perl Makefile.PL>

=item C<make>

=item C<make install>

May need root permissions

=item Edit your F</opt/rt4/etc/RT_SiteConfig.pm>

Add this line:

    Plugin('RT::Extension::FormattedTransactions');

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=back

=head1 AUTHOR

Best Practical Solutions, LLC E<lt>modules@bestpractical.comE<gt>

=for html <p>All bugs should be reported via email to <a
href="mailto:bug-RT-Extension-FormattedTransactions@rt.cpan.org">bug-RT-Extension-FormattedTransactions@rt.cpan.org</a>
or via the web at <a
href="http://rt.cpan.org/Public/Dist/Display.html?Name=RT-Extension-FormattedTransactions">rt.cpan.org</a>.</p>

=for text
    All bugs should be reported via email to
        bug-RT-Extension-FormattedTransactions@rt.cpan.org
    or via the web at
        http://rt.cpan.org/Public/Dist/Display.html?Name=RT-Extension-FormattedTransactions

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2020 by Best Practical Solutions, LLC.

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

1;
