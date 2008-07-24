%module "Math::GSL::Histogram"
%include "typemaps.i"
%include "gsl_typemaps.i"

%apply int *OUTPUT { double * lower, double * upper, size_t * i};

FILE * fopen(char *, char *);
int fclose(FILE *);

%{
    #include "gsl/gsl_histogram.h"
%}

%include "gsl/gsl_histogram.h"


%perlcode %{
@EXPORT_OK = qw/fopen fclose
               gsl_histogram_alloc 
               gsl_histogram_calloc 
               gsl_histogram_calloc_uniform 
               gsl_histogram_free 
               gsl_histogram_increment 
               gsl_histogram_accumulate 
               gsl_histogram_find 
               gsl_histogram_get 
               gsl_histogram_get_range 
               gsl_histogram_max 
               gsl_histogram_min 
               gsl_histogram_bins 
               gsl_histogram_reset 
               gsl_histogram_calloc_range 
               gsl_histogram_set_ranges 
               gsl_histogram_set_ranges_uniform 
               gsl_histogram_memcpy 
               gsl_histogram_clone 
               gsl_histogram_max_val 
               gsl_histogram_max_bin 
               gsl_histogram_min_val 
               gsl_histogram_min_bin 
               gsl_histogram_equal_bins_p 
               gsl_histogram_add 
               gsl_histogram_sub 
               gsl_histogram_mul 
               gsl_histogram_div 
               gsl_histogram_scale 
               gsl_histogram_shift 
               gsl_histogram_sigma 
               gsl_histogram_mean 
               gsl_histogram_sum 
               gsl_histogram_fwrite 
               gsl_histogram_fread 
               gsl_histogram_fprintf 
               gsl_histogram_fscanf 
               gsl_histogram_pdf_alloc 
               gsl_histogram_pdf_init 
               gsl_histogram_pdf_free 
               gsl_histogram_pdf_sample 
             /;
%EXPORT_TAGS = ( all => [ @EXPORT_OK ] );

=head1 NAME

Math::GSL::Histogram - Create and manipulate histograms of data

=head1 SYNOPSIS

    use Math::GSL::Histogram qw/:all/;

    my $H = gsl_histogram_alloc(100);
    gsl_histogram_set_ranges_uniform($H,0,101);
    gsl_histogram_increment($H, -50 );  # ignored
    gsl_histogram_increment($H, 70 );   
    gsl_histogram_increment($H, 85.2 );

    my $G = gsl_histogram_clone($H);
    my $value = gsl_histogram_get($G, 70);
    my ($max,$min) = (gsl_histogram_min_val($H), gsl_histogram_max_val($H) );
    my $sum = gsl_histogram_sum($H);

=cut

=head1 DESCRIPTION

Here is a list of all the functions included in this module :

=over 1

=item C<gsl_histogram_alloc($n)> - This function allocates memory for a histogram with $n bins, and returns a pointer to a newly created gsl_histogram struct. The bins and ranges are not initialized, and should be prepared using one of the range-setting functions below in order to make the histogram ready for use. 

=item C<gsl_histogram_calloc >

=item C<gsl_histogram_calloc_uniform >

=item C<gsl_histogram_free($h)> - This function frees the histogram $h and all of the memory associated with it.

=item C<gsl_histogram_increment($h, $x)> - This function updates the histogram $h by adding one (1.0) to the bin whose range contains the coordinate $x. If $x lies in the valid range of the histogram then the function returns zero to indicate success. If $x is less than the lower limit of the histogram then the function returns $GSL_EDOM, and none of bins are modified. Similarly, if the value of $x is greater than or equal to the upper limit of the histogram then the function returns $GSL_EDOM, and none of the bins are modified. The error handler is not called, however, since it is often necessary to compute histograms for a small range of a larger dataset, ignoring the values outside the range of interest. 

=item C<gsl_histogram_accumulate($h, $x, $weight)> - This function is similar to gsl_histogram_increment but increases the value of the appropriate bin in the histogram $h by the floating-point number weight.

=item C<gsl_histogram_find($h, $x)> - This function finds the bin number which covers the coordinate $x in the histogram $h. The bin is located using a binary search. The search includes an optimization for histograms with uniform range, and will return the correct bin immediately in this case. If $x is found in the range of the histogram then the function returns the bin number and returns $GSL_SUCCESS. If $x lies outside the valid range of the histogram then the function returns $GSL_EDOM and the error handler is invoked.

=item C<gsl_histogram_get($h, $i)> - This function returns the contents of the $i-th bin of the histogram $h. If $i lies outside the valid range of indices for the histogram then the error handler is called with an error code of GSL_EDOM and the function returns 0. 

=item C<gsl_histogram_get_range($h, $i)> - This function finds the upper and lower range limits of the $i-th bin of the histogram $h. If the index $i is valid then the corresponding range limits are returned after the 0 in this order : lower and then upper. The lower limit is inclusive (i.e. events with this coordinate are included in the bin) and the upper limit is exclusive (i.e. events with the coordinate of the upper limit are excluded and fall in the neighboring higher bin, if it exists). The function returns 0 to indicate success. If i lies outside the valid range of indices for the histogram then the error handler is called and the function returns an error code of $GSL_EDOM.

=item C<gsl_histogram_max($h)> - This function returns the maximum upper limit of the histogram $h. It provides a way of determining this value without accessing the gsl_histogram struct directly. 

=item C<gsl_histogram_min($h)> - This function returns the minimum lower range limit of the histogram $h. It provides a way of determining this value without accessing the gsl_histogram struct directly. 

=item C<gsl_histogram_bins($h)> - This function returns the number of bins of the histogram $h limit. It provides a way of determining this value without accessing the gsl_histogram struct directly. 
 
=item C<gsl_histogram_reset($h)> - This function resets all the bins in the histogram $h to zero. 

=item C<gsl_histogram_calloc_range>

=item C<gsl_histogram_set_ranges($h, $range, $size)> - This function sets the ranges of the existing histogram $h using the array $range of size $size. The values of the histogram bins are reset to zero. The $range array should contain the desired bin limits. The ranges can be arbitrary, subject to the restriction that they are monotonically increasing. Note that the size of the $range array should be defined to be one element bigger than the number of bins. The additional element is required for the upper value of the final bin.

=item C<gsl_histogram_set_ranges_uniform($h, $xmin, $xmax)> - This function sets the ranges of the existing histogram $h to cover the range $xmin to $xmax uniformly. The values of the histogram bins are reset to zero. The bin ranges are shown in the table below,

=over

=item  bin[0] corresponds to xmin <= x < xmin + d

=item  bin[1] corresponds to xmin + d <= x < xmin + 2 d

=item  ......

=item  bin[n-1] corresponds to xmin + (n-1)d <= x < xmax

=back

where d is the bin spacing, d = (xmax-xmin)/n. 

=over

=item C<gsl_histogram_memcpy($dest, $src)> - This function copies the histogram $src into the pre-existing histogram $dest, making $dest into an exact copy of $src. The two histograms must be of the same size.

=item C<gsl_histogram_clone($src)> - This function returns a pointer to a newly created histogram which is an exact copy of the histogram $src.

=item C<gsl_histogram_max_val($h)> - This function returns the maximum value contained in the histogram bins. 

=item C<gsl_histogram_max_bin($h)> - This function returns the index of the bin containing the maximum value. In the case where several bins contain the same maximum value the smallest index is returned.

=item C<gsl_histogram_min_val($h)> - This function returns the minimum value contained in the histogram bins.

=item C<gsl_histogram_min_bin($h)> - This function returns the index of the bin containing the minimum value. In the case where several bins contain the same maximum value the smallest index is returned.

=item C<gsl_histogram_equal_bins_p($h1, $h2)> - This function returns 1 if the all of the individual bin ranges of the two histograms are identical, and 0 otherwise.

=item C<gsl_histogram_add($h1, $h2)> - This function adds the contents of the bins in histogram $h2 to the corresponding bins of histogram $h1, i.e. h'_1(i) = h_1(i) + h_2(i). The two histograms must have identical bin ranges.

=item C<gsl_histogram_sub($h1, $h2)> - This function subtracts the contents of the bins in histogram $h2 from the corresponding bins of histogram $h1, i.e. h'_1(i) = h_1(i) - h_2(i). The two histograms must have identical bin ranges.

=item C<gsl_histogram_mul($h1, $h2)> - This function multiplies the contents of the bins of histogram $h1 by the contents of the corresponding bins in histogram $h2, i.e. h'_1(i) = h_1(i) * h_2(i). The two histograms must have identical bin ranges.

=item C<gsl_histogram_div($h1, $h2)> - This function divides the contents of the bins of histogram $h1 by the contents of the corresponding bins in histogram $h2, i.e. h'_1(i) = h_1(i) / h_2(i). The two histograms must have identical bin ranges.

=item C<gsl_histogram_scale($h, $scale)> - This function multiplies the contents of the bins of histogram $h by the constant $scale, i.e. h'_1(i) = h_1(i) * scale. 

=item C<gsl_histogram_shift($h, $offset)> - This function shifts the contents of the bins of histogram $h by the constant $offset, i.e. h'_1(i) = h_1(i) + offset. 

=item C<gsl_histogram_sigma($h)> - This function returns the standard deviation of the histogrammed variable, where the histogram is regarded as a probability distribution. Negative bin values are ignored for the purposes of this calculation. The accuracy of the result is limited by the bin width.

=item C<gsl_histogram_mean($h)> - This function returns the mean of the histogrammed variable, where the histogram is regarded as a probability distribution. Negative bin values are ignored for the purposes of this calculation. The accuracy of the result is limited by the bin width. 

=item C<gsl_histogram_sum($h)> - This function returns the sum of all bin values. Negative bin values are included in the sum.

=item C<gsl_histogram_fwrite($stream, $h)> - This function writes the ranges and bins of the histogram $h to the stream $stream, which has been opened by the fopen function, in binary format. The return value is 0 for success and $GSL_EFAILED if there was a problem writing to the file. Since the data is written in the native binary format it may not be portable between different architectures.

=item C<gsl_histogram_fread($stream, $h)> - This function reads into the histogram $h from the open stream stream in binary format. The histogram $h must be preallocated with the correct size since the function uses the number of bins in $h to determine how many bytes to read. The return value is 0 for success and $GSL_EFAILED if there was a problem reading from the file. The data is assumed to have been written in the native binary format on the same architecture.

=item C<gsl_histogram_fprintf($stream, $h, $range_format, $bin_format)> - This function writes the ranges and bins of the histogram $h line-by-line to the stream $stream (from the fopen function) using the format specifiers $range_format and $bin_format. These should be one of the %g, %e or %f formats for floating point numbers. The function returns 0 for success and $GSL_EFAILED if there was a problem writing to the file. The histogram output is formatted in three columns, and the columns are separated by spaces, like this,

=over

=item range[0] range[1] bin[0]
     
=item range[1] range[2] bin[1]

=item range[2] range[3] bin[2]

=item ....

=item range[n-1] range[n] bin[n-1]

=back

The values of the ranges are formatted using range_format and the value of the bins are formatted using bin_format. Each line contains the lower and upper limit of the range of the bins and the value of the bin itself. Since the upper limit of one bin is the lower limit of the next there is duplication of these values between lines but this allows the histogram to be manipulated with line-oriented tools. 

=item C<gsl_histogram_fscanf($stream, $h)> - This function reads formatted data from the stream $stream into the histogram $h. The data is assumed to be in the three-column format used by gsl_histogram_fprintf. The histogram $h must be preallocated with the correct length since the function uses the size of $h to determine how many numbers to read. The function returns 0 for success and $GSL_EFAILED if there was a problem reading from the file.

=item C<gsl_histogram_pdf_alloc($n)> - This function allocates memory for a probability distribution with $n bins and returns a pointer to a newly initialized gsl_histogram_pdf struct. If insufficient memory is available a null pointer is returned and the error handler is invoked with an error code of $GSL_ENOMEM.

=item C<gsl_histogram_pdf_init($p, $h)> - This function initializes the probability distribution $p with the contents of the histogram $h. If any of the bins of $h are negative then the error handler is invoked with an error code of $GSL_EDOM because a probability distribution cannot contain negative values.

=item C<gsl_histogram_pdf_free($p)> - This function frees the probability distribution function $p and all of the memory associated with it.

=item C<gsl_histogram_pdf_sample($p, $r)> -     This function uses $r, a uniform random number between zero and one, to compute a single random sample from the probability distribution $p. The algorithm used to compute the sample s is given by the following formula, s = range[i] + delta * (range[i+1] - range[i]) where i is the index which satisfies sum[i] <= r < sum[i+1] and delta is (r - sum[i])/(sum[i+1] - sum[i]).

=head1 EXAMPLES

 The following example shows how to create a histogram with logarithmic bins with ranges [1,10), [10,100) and [100,1000).

 $h = gsl_histogram_alloc (3);
             
 # bin[0] covers the range 1 <= x < 10
 # bin[1] covers the range 10 <= x < 100
 # bin[2] covers the range 100 <= x < 1000
  
 $range = [ 1.0, 10.0, 100.0, 1000.0 ];
              
 gsl_histogram_set_ranges($h, $range, 4);

=head1 AUTHORS

Jonathan Leto <jonathan@leto.net> and Thierry Moisan <thierry.moisan@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 Jonathan Leto and Thierry Moisan

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

%}
