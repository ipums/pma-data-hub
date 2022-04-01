---
title: "Family Planning Panel Data Now Available from IPUMS PMA"
description: |
  This month's data release includes Phase 2 panel data from 6 samples, plus Phase 1 panel data from 3 new countries.
date: 2022-03-01
output:
  distill::distill_article:
    self_contained: false
    toc: true
    toc_depth: 3
    toc_float: true
author:
  - name: Matt Gunther
    affiliation: IPUMS PMA Senior Data Analyst
  - name: Devon Kristiansen
    affiliation: IPUMS PMA Project Manager
    url: https://www.linkedin.com/in/devonkristiansen
categories:
  - Panel Data
  - Data Discovery
  - New Data
  - Family Planning 
  - Weights
  - Cluster Sampling
preview: ../../images/new_data.png
---

<div class="layout-chunk" data-layout="l-body">


</div>


This month, IPUMS is excited to announce the release of **harmonized panel data** focused on the reproductive and sexual health of women surveyed by our partners at [Performance Monitoring for Action](https://www.pmadata.org/) (PMA). Participating women will be interviewed up to three times over three years, so we've made big changes to our [data extract system](https://pma.ipums.org/) making it easy to compare an individual's responses across multiple rounds of data collection. Cross-sectional samples of women, households, and service delivery points remain available as before, but we've also streamlined navigation for users interested in longitudinal analysis with these new panel surveys. 

Here on the IPUMS PMA blog, today marks the beginning of a [new series](../../index.html#category:Panel_Data) in which we'll be using R to: 

  * import and explore the structure of IPUMS PMA panel data
  * understand key sample design and follow-up issues 
  * build indicators measuring change in contraceptive use status and family planning outcomes
  * analyze monthly recall data from the included [contraceptive calendar](../../index.html#category:Contraceptive_Calendar) 

Additionally, we're also developing a second **online course** for newcomers to longitudinal analysis that will complement our existing [Introduction to IPUMS PMA Data Analysis](../../introduction.html). Later this year, we also plan to release a PDF **longitudinal handbook** adapted from this blog that will include examples in **both R and Stata**. Stay tuned for further announcements here and [on Twitter](https://twitter.com/ipumsGH) in the coming weeks.

<aside>
PMA has also published a **cross-sectional handbook** in both [English](https://www.pmadata.org/media/1243/download?attachment) and [French](https://www.pmadata.org/media/1244/download?attachment).
</aside>

# Background

Dating back to 2013, the original PMA survey design included high-frequency, **cross-sectional** samples of women and service delivery points collected from eleven countries participating in [Family Planning 2020](http://progress.familyplanning2020.org/) (FP2020) - a global partnership that supports the rights of women and girls to decide for themselves whether, when, and how many children they want to have. These surveys were designed to monitor annual progress towards [FP2020 goals](http://progress.familyplanning2020.org/measurement) via population-level estimates for several [core indicators](http://www.track20.org/pages/data_analysis/core_indicators/overview.php). 

Beginning in 2019, PMA surveys were redesigned under a renewed partnership called [Family Planning 2030](https://fp2030.org/) (FP2030). These new surveys have been refocused on reproductive and sexual health indicators, and they feature a **longitudinal panel** of women of childbearing age. This design will allow researchers to measure contraceptive dynamics and changes in women’s fertility intentions over a **three year period** via annual in-person interviews.^[In addition to these three in-person surveys, PMA also conducted telephone interviews with panel members focused on emerging issues related to the COVID-19 pandemic in 2020. These telephone surveys are already available for several countries - see our series on [PMA COVID-19 surveys](../../index.html#category:COVID-19) for details.] 

Questions on the redesigned survey cover topics like:

  * awareness, perception, knowledge, and use of contraceptive methods
  * perceived quality and side effects of contraceptive methods among current users
  * birth history and fertility intentions 
  * aspects of health service provision 
  * domains of empowerment 
  
# Sampling 

PMA panel data includes a mixture of **nationally representative** and **sub-nationally representative** samples from eight participating countries. The panel study consists of three data collection phases, each spaced one year apart. IPUMS PMA has released data from the first *two* phases for countries where Phase 1 data collection began in 2019; we have released data from only the *first* phase for countries where Phase 1 data collection began in August or September 2020. Phase 3 data collection and processing is currently underway. 

<div class="layout-chunk" data-layout="l-body-outset">
<div style="margin-bottom: 1em; margin-top: 0em; border: 0px solid #ddd; padding: 5pxoverflow-x: scroll; width:100%; border-bottom: 0;">
<table style="width:100%; margin-left: auto; margin-right: auto;" class="table">
 <thead>
<tr>
<th style="empty-cells: hide;border-bottom:hidden;" colspan="2"></th>
<th style="border-bottom:hidden;padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; " colspan="3"><div style="border-bottom: 1px solid #ddd; padding-bottom: 5px; ">Now Available from IPUMS PMA</div></th>
</tr>
  <tr>
   <th style="text-align:left;"> Sample </th>
   <th style="text-align:left;"> Phase 1 Data Collection<sup>*</sup> </th>
   <th style="text-align:left;"> Phase 1 </th>
   <th style="text-align:left;"> Phase 2 </th>
   <th style="text-align:left;"> Phase 3 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Burkina Faso </td>
   <td style="text-align:left;"> Dec 2019 - Mar 2020 </td>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Cote d'Ivoire </td>
   <td style="text-align:left;"> Sep 2020 - Dec 2020 </td>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DRC - Kinshasa </td>
   <td style="text-align:left;"> Dec 2019 - Feb 2020 </td>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DRC - Kongo Central </td>
   <td style="text-align:left;"> Dec 2019 - Feb 2020 </td>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> India - Rajasthan </td>
   <td style="text-align:left;"> Aug 2020 - Oct 2020 </td>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Kenya </td>
   <td style="text-align:left;"> Nov 2019 - Dec 2019 </td>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nigeria - Kano </td>
   <td style="text-align:left;"> Dec 2019 - Jan 2020 </td>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nigeria - Lagos </td>
   <td style="text-align:left;"> Dec 2019 - Jan 2020 </td>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Uganda </td>
   <td style="text-align:left;"> Sep 2020 - Oct 2020 </td>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
</tbody>
</table>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup>*</sup> <em>Each data collection phase is spaced one year apart</em>
</td></tr></tfoot>
</div>

</div>


<div>
PMA uses a multi-stage clustered sample design, with stratification at the urban-rural level or by sub-region. Geographically defined sample clusters - called [enumeration areas](https://pma.ipums.org/pma-action/variables/EAID#description_section) (EAs) -- are provided by the national statistics agency in each country.^[[Displaced GPS coordinates](https://tech.popdata.org/pma-data-hub/posts/2021-10-15-nutrition-climate/PMA_displacement.pdf) for the centroid of each EA are available for most samples [by request](https://www.pmadata.org/data/request-access-datasets) from PMA. IPUMS PMA provides shapefiles for PMA countries [here](https://internal.pma.ipums.org/pma/gis_boundary_files.shtml).] These EAs are sampled using a *probability proportional to size* (PPS) method relative to the population distribution in each stratum.

At Phase 1, 35 household dwellings were selected at random within each EA. Resident enumerators visited each dwelling and invited one household member to complete a [Household Questionnaire](https://pma.ipums.org/pma/resources/questionnaires/hhf/PMA-Household-Questionnaire-English-2019.10.09.pdf)^[Questionnaires administered in each country may vary from this **Core Household Questionnaire** - [click here](https://pma.ipums.org/pma/enum_materials.shtml) for details.] that includes a census of all household members and visitors who stayed there during the night before the interview. Female household members and visitors aged 15-49 were then invited to complete a subsequent Phase 1 [Female Questionnaire](https://pma.ipums.org/pma/resources/questionnaires/hhf/PMA-Female-Questionnaire-English-2019.10.09.pdf).^[Questionnaires administered in each country may vary from this **Core Female Questionnaire** - [click here](https://pma.ipums.org/pma/enum_materials.shtml) for details.]
</div>

<aside>
Questionnaires are administered in-person by **resident enumerators** visiting selected households in each EA. These are typically women over age 21 living in (or near) each EA and who hold at least a high school diploma.
</aside>

One year later, resident enumerators visited the same dwellings and administered a Phase 2 Household Questionnaire. A panel member in Phase 2 is any woman still age 15-49 who could be reached for a second Female Questionnaire, either because:

  * she still lived there, or
  * she had moved elsewhere within the study area,^[The "study area" is area within which resident enumerators should attempt to find panel women that have moved out of their Phase 1 dwelling. This may extend beyond the woman's original EA as determined by in-country administrators - see [PMA Phase 2 and Phase 3 Survey Protocol](https://www.pmadata.org/data/survey-methodology) for details.] but at least one member of the Phase 1 household remained and could help resident enumerators locate her new dwelling.^[In cases where no Phase 1 household members remained in the dwelling at Phase 2, women from the household are considered lost to follow-up (LTFU). A panel member is also considered LTFU if a Phase 2 Household Questionnaire was not completed, if she declined to participate, or if she was deceased or otherwise unavailable.]
  
<aside>
[SAMEDWELLING](https://pma.ipums.org/pma-action/variables/SAMEDWELLING#codes_section) indicates whether a Phase 2 female respondent resided in her Phase 1 dwelling or a new one. 
</aside>
  
Additionally, resident enumerators administered the Phase 2 Female Questionnaire to *new* women in sampled households who:

  * reached age 15 after Phase 1
  * joined the household after Phase 1
  * declined the Female Questionnaire at Phase 1, but agreed to complete it at Phase 2
  
<aside>
[PANELWOMAN](https://pma.ipums.org/pma-action/variables/PANELWOMAN#codes_section) indicates whether a Phase 2 household member completed the Phase 1 Female Questionnaire.  
</aside>

When you select the new **Longitudinal** sample option at checkout, you'll be able to include responses from every available phase of the study. These samples are available in either "long" format (responses from each phase will be organized in separate rows) or "wide" format (responses from each phase will be organized in columns). 

<div class="layout-chunk" data-layout="l-body">
<img src="images/long_radio.png" width="1011" />

</div>


In addition to following up with women in the panel over time, PMA also adjusted sampling so that a cross-sectional sample could be produced concurrently with each data collection phase. These samples mainly overlap with the data you'll obtain for a particular phase in the longitudinal sample, except that replacement households were drawn from each EA where more than 10% of households from the previous phase were no longer there. Conversely, panel members who were located in a new dwelling at Phase 2 will not be represented in the cross-sectional sample drawn from that EA. These adjustments ensure that population-level indicators may be derived from cross-sectional samples in a given year, even if panel members move or are lost to follow-up. 

<aside>
[CROSS_SECTION](https://pma.ipums.org/pma-action/variables/CROSS_SECTION#codes_section) indicates whether a household member in a longitudinal sample is also included in the cross-sectional sample for a given year (every person in a cross-sectional sample is included in the longitudinal sample). 

We'll cover **sample composition** in much greater detail in an upcoming post.
</aside>

You'll find PMA cross-sectional samples dating back to 2013 if you select the **Cross-sectional** sample option at checkout. 

<div class="layout-chunk" data-layout="l-body">
<img src="images/cross_radio.png" width="1012" />

</div>


# Weights and Clusters

Whether you intend to work with a new **Longitudinal** or **Cross-sectional** data extract, you'll find the same set of sampling weights available for all PMA Family Planning surveys dating back to 2013. 

  * [HQWEIGHT](https://pma.ipums.org/pma-action/variables/HQWEIGHT#description_section) can be used to generate cross-sectional population estimates from questions on the Household Questionnaire.^[`HQWEIGHT` reflects the [calculated selection probability](https://internal.pma.ipums.org/pma/resources/documentation/weighting_memo.pdf) for a household in an EA, normalized at the population-level. Users intending to estimate population-level indicators for *households* should restrict their sample to one person per household via [LINENO](https://pma.ipums.org/pma-action/variables/LINENO#description_section) - see [household weighting guide](https://internal.pma.ipums.org/pma/weightguide.shtml#hh) for details.]
  * [FQWEIGHT](https://pma.ipums.org/pma-action/variables/FQWEIGHT#description_section) can be used to to generate cross-sectional population estimates from questions on the Female Questionnaire.^[`FQWEIGHT` adjusts `HQWEIGHT` for female non-response within the EA, normalized at the population-level - see [female weighting guide](https://internal.pma.ipums.org/pma/weightguide.shtml#female) for details.]
  * [EAWEIGHT](https://pma.ipums.org/pma-action/variables/EAWEIGHT#description_section) can be used to compare the selection probability of a particular household with that of its EA. 
  
<aside>
A fourth Family Planning survey weight, [POPWT](https://pma.ipums.org/pma-action/variables/POPWT#description_section), is currently available only for **Cross-sectional** data extracts and Phase 1 panel data.^[`POPWT` can be used to estimate population-level *counts* - [click here](https://internal.pma.ipums.org/pma/population_weights.shtml) or check out [this video](https://www.youtube.com/watch?v=GnCq26t4zgM) for details.] 
</aside>

Additionally, PMA created a new weight, [PANELWEIGHT](https://pma.ipums.org/pma-action/variables/PANELWEIGHT#description_section), 
which should be used in longitudinal analyses spanning multiple phases, as it adjusts for loss to follow-up. `PANELWEIGHT` is available only for **Longitudinal** data extracts. 

In upcoming posts, we'll use the [srvyr](http://gdfe.co/srvyr/index.html) package to weight longitudinal indicators with `PANELWEIGHT`.^[The `srvyr` package is a [tidy](https://tidyverse.tidyverse.org/) implementation of the popular [survey](http://r-survey.r-forge.r-project.org/survey/) package for R, authored by Dr. Thomas Lumley. For thorough discussion of the types of weights available in both R and Stata, we recommend [this blog post](https://notstatschat.rbind.io/2020/08/04/weights-in-statistics/) by Dr. Lumley.] For example, suppose we wanted to estimate the proportion of reproductive age women in Burkina Faso who were using contraception at the time of data collection for both Phase 1 and Phase 2. In a "wide" longitudinal extract, you'll find responses from this survey question recorded in `CP_1` for Phase 1, and in `CP_2` for Phase 2. 

<aside>
Variable names in a "wide" extract have a numeric suffix corresponding with a data collection phase. `CP_1` is the Phase 1 version of [CP](https://pma.ipums.org/pma-action/variables/CP#codes_section), while `CP_2` comes from Phase 2. 
</aside>

<div class="layout-chunk" data-layout="l-body">


</div>


<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class='va'>dat</span> <span class='op'>%&gt;%</span> <span class='fu'>count</span><span class='op'>(</span><span class='va'>CP_1</span>, <span class='va'>CP_2</span><span class='op'>)</span>
</code></pre></div>

```
# A tibble: 5 × 3
                                   CP_1      CP_2     n
                              <int+lbl> <int+lbl> <int>
1  0 [No]                                 0 [No]   2589
2  0 [No]                                 1 [Yes]   821
3  1 [Yes]                                0 [No]    556
4  1 [Yes]                                1 [Yes]  1241
5 99 [NIU (not in universe) or missing]   0 [No]      5
```

</div>


The `srvyr` package provides two functions we'll need to obtain our population estimate. The first, [as_survey_design](http://gdfe.co/srvyr/reference/as_survey_design.html), allows us to specify `PANELWEIGHT` as a sampling weight. The second, [survey_mean](http://gdfe.co/srvyr/reference/survey_mean.html), uses that weight in an estimating function; in this case, we'll get the estimated proportion where `CP_1` and `CP_2` both have the value `1 [Yes]` after removing missing / NIU responses with `CP_1 != 99`.

<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class='kw'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='op'>(</span><span class='va'><a href='http://gdfe.co/srvyr/'>srvyr</a></span><span class='op'>)</span>

<span class='va'>dat</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> 
  <span class='fu'><a href='http://gdfe.co/srvyr/reference/as_survey_design.html'>as_survey_design</a></span><span class='op'>(</span>weight <span class='op'>=</span> <span class='va'>PANELWEIGHT</span><span class='op'>)</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> 
  <span class='fu'><a href='http://gdfe.co/srvyr/reference/dplyr_single.html'>filter</a></span><span class='op'>(</span><span class='va'>CP_1</span> <span class='op'>!=</span> <span class='fl'>99</span><span class='op'>)</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> 
  <span class='fu'><a href='http://gdfe.co/srvyr/reference/summarise.html'>summarize</a></span><span class='op'>(</span><span class='fu'><a href='http://gdfe.co/srvyr/reference/survey_mean.html'>survey_mean</a></span><span class='op'>(</span><span class='va'>CP_1</span> <span class='op'>*</span> <span class='va'>CP_2</span><span class='op'>)</span><span class='op'>)</span>
</code></pre></div>

```
# A tibble: 1 × 2
   coef   `_se`
  <dbl>   <dbl>
1 0.188 0.00733
```

</div>


<aside>
`coef` shows the estimated population proportion

`_se` shows the standard error for this estimate
</aside>

This estimate suggests that 18.8% of all reproductive age women in Burkina Faso would have been using contraception when both Phase 1 and Phase 2 data were collected. The standard error 0.00733 is shown by default, but we can choose a confidence interval "ci" for a specified confidence level if desired. 

<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class='va'>dat</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> 
  <span class='fu'><a href='http://gdfe.co/srvyr/reference/as_survey_design.html'>as_survey_design</a></span><span class='op'>(</span>weight <span class='op'>=</span> <span class='va'>PANELWEIGHT</span><span class='op'>)</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> 
  <span class='fu'><a href='http://gdfe.co/srvyr/reference/dplyr_single.html'>filter</a></span><span class='op'>(</span><span class='va'>CP_1</span> <span class='op'>!=</span> <span class='fl'>99</span><span class='op'>)</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> 
  <span class='fu'><a href='http://gdfe.co/srvyr/reference/summarise.html'>summarize</a></span><span class='op'>(</span>
    <span class='fu'><a href='http://gdfe.co/srvyr/reference/survey_mean.html'>survey_mean</a></span><span class='op'>(</span>
      <span class='va'>CP_1</span> <span class='op'>*</span> <span class='va'>CP_2</span>,
      vartype <span class='op'>=</span> <span class='st'>"ci"</span>,
      level <span class='op'>=</span> <span class='fl'>0.99</span>
    <span class='op'>)</span>
  <span class='op'>)</span>
</code></pre></div>

```
# A tibble: 1 × 3
   coef `_low` `_upp`
  <dbl>  <dbl>  <dbl>
1 0.188  0.169  0.207
```

</div>


<aside>
`_low` and `_upp` show the lower and upper bounds of a 99% confidence interval
</aside>

For binary variables where the estimated proportion approaches 0% or 100%, it's often useful to obtain an asymmetric confidence interval that cannot exceed those values. Consider, for example, the proportion of women who were pregnant at Phase 1 and again just 12 months later at Phase 2 (excluding women who were unsure or did not respond in either phase): 

<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class='va'>dat</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> 
  <span class='fu'><a href='http://gdfe.co/srvyr/reference/dplyr_single.html'>filter</a></span><span class='op'>(</span><span class='va'>PREGNANT_1</span> <span class='op'>&lt;</span> <span class='fl'>90</span>, <span class='va'>PREGNANT_2</span> <span class='op'>&lt;</span> <span class='fl'>90</span><span class='op'>)</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> 
  <span class='fu'>count</span><span class='op'>(</span><span class='va'>PREGNANT_1</span>, <span class='va'>PREGNANT_2</span><span class='op'>)</span>
</code></pre></div>

```
# A tibble: 4 × 3
  PREGNANT_1 PREGNANT_2     n
   <int+lbl>  <int+lbl> <int>
1    0 [No]     0 [No]   4379
2    0 [No]     1 [Yes]   364
3    1 [Yes]    0 [No]    391
4    1 [Yes]    1 [Yes]    11
```

</div>


Only 11 such women were found in the Burkina Faso sample, so we should expect the population estimate to be very close to 0%. 

<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class='va'>dat</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> 
  <span class='fu'><a href='http://gdfe.co/srvyr/reference/dplyr_single.html'>filter</a></span><span class='op'>(</span><span class='va'>PREGNANT_1</span> <span class='op'>&lt;</span> <span class='fl'>90</span>, <span class='va'>PREGNANT_2</span> <span class='op'>&lt;</span> <span class='fl'>90</span><span class='op'>)</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> 
  <span class='fu'><a href='http://gdfe.co/srvyr/reference/as_survey_design.html'>as_survey_design</a></span><span class='op'>(</span>weight <span class='op'>=</span> <span class='va'>PANELWEIGHT</span><span class='op'>)</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> 
  <span class='fu'><a href='http://gdfe.co/srvyr/reference/summarise.html'>summarize</a></span><span class='op'>(</span>
    <span class='fu'><a href='http://gdfe.co/srvyr/reference/survey_mean.html'>survey_mean</a></span><span class='op'>(</span>
      <span class='va'>PREGNANT_1</span> <span class='op'>*</span> <span class='va'>PREGNANT_2</span>,
      vartype <span class='op'>=</span> <span class='st'>"ci"</span>,
      level <span class='op'>=</span> <span class='fl'>0.99</span>
    <span class='op'>)</span>
  <span class='op'>)</span>
</code></pre></div>

```
# A tibble: 1 × 3
     coef    `_low`  `_upp`
    <dbl>     <dbl>   <dbl>
1 0.00268 -0.000264 0.00563
```

</div>


<aside>
`_low` shows a negative value: our confidence interval should not include values below 0%
</aside>

The `survey_mean` function accepts several methods for setting a lower limit on `_low`. We'll use `proportion = TRUE` to employ a method selected by `prop_method`. The "logit" method calculates a Wald-type confidence interval on the log-odds scale; Stata users will notice that it reproduces results obtained with `svy: prop`.^[See [svyciprop](https://rdrr.io/pkg/survey/man/svyciprop.html) for additional methods.]

<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class='va'>dat</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> 
  <span class='fu'><a href='http://gdfe.co/srvyr/reference/as_survey_design.html'>as_survey_design</a></span><span class='op'>(</span>weight <span class='op'>=</span> <span class='va'>PANELWEIGHT</span><span class='op'>)</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> 
  <span class='fu'><a href='http://gdfe.co/srvyr/reference/dplyr_single.html'>filter</a></span><span class='op'>(</span><span class='va'>PREGNANT_1</span> <span class='op'>&lt;</span> <span class='fl'>90</span>, <span class='va'>PREGNANT_2</span> <span class='op'>&lt;</span> <span class='fl'>90</span><span class='op'>)</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> 
  <span class='fu'><a href='http://gdfe.co/srvyr/reference/summarise.html'>summarize</a></span><span class='op'>(</span>
    <span class='fu'><a href='http://gdfe.co/srvyr/reference/survey_mean.html'>survey_mean</a></span><span class='op'>(</span>
      <span class='va'>PREGNANT_1</span> <span class='op'>*</span> <span class='va'>PREGNANT_2</span>,
      vartype <span class='op'>=</span> <span class='st'>"ci"</span>,
      level <span class='op'>=</span> <span class='fl'>0.99</span>,
      proportion <span class='op'>=</span> <span class='cn'>TRUE</span>,
      prop_method <span class='op'>=</span> <span class='st'>"logit"</span>
    <span class='op'>)</span>
  <span class='op'>)</span>
</code></pre></div>

```
# A tibble: 1 × 3
     coef   `_low`  `_upp`
    <dbl>    <dbl>   <dbl>
1 0.00268 0.000894 0.00803
```

</div>


Compared with the non-adjusted standard error, the Wald-type confidence interval contains only values between 0% and 100%. Also notice that the interval is asymmetrical for values close to these limits.

<div class="layout-chunk" data-layout="l-page">
<img src="phase2-discovery_files/figure-html5/unnamed-chunk-11-1.png" width="1152" />

</div>


You can also provide information about sample clusters via [as_survey_design](http://gdfe.co/srvyr/reference/as_survey_design.html). In general, we expect households selected from the same EA to share certain characteristics, such that some degree of variation seen in a variable of interest may be non-random at the EA-level. To compensate, you may wish the expand the standard errors produced by `survey_mean` by providing EA identifiers in [EAID](https://pma.ipums.org/pma-action/variables/EAID#codes_section).

<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class='va'>dat</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> 
  <span class='fu'><a href='http://gdfe.co/srvyr/reference/as_survey_design.html'>as_survey_design</a></span><span class='op'>(</span>weight <span class='op'>=</span> <span class='va'>PANELWEIGHT</span>, id <span class='op'>=</span> <span class='va'>EAID_2</span><span class='op'>)</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> 
  <span class='fu'><a href='http://gdfe.co/srvyr/reference/dplyr_single.html'>filter</a></span><span class='op'>(</span><span class='va'>CP_1</span> <span class='op'>!=</span> <span class='fl'>99</span><span class='op'>)</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> 
  <span class='fu'><a href='http://gdfe.co/srvyr/reference/summarise.html'>summarize</a></span><span class='op'>(</span><span class='fu'><a href='http://gdfe.co/srvyr/reference/survey_mean.html'>survey_mean</a></span><span class='op'>(</span><span class='va'>CP_1</span> <span class='op'>*</span> <span class='va'>CP_2</span><span class='op'>)</span><span class='op'>)</span>
</code></pre></div>

```
# A tibble: 1 × 2
   coef  `_se`
  <dbl>  <dbl>
1 0.188 0.0130
```

</div>


Compared with our original estimate, notice that the 99% confidence interval for our contraceptive use estimate is *wider* when we provide information about the clustered sample design - these are "cluster-robust" standard errors.

<div class="layout-chunk" data-layout="l-page">
<img src="phase2-discovery_files/figure-html5/unnamed-chunk-13-1.png" width="1152" />

</div>


# Inclusion Criteria for Analysis 

In the remainder of [this series](../../index.html#category:Panel_Data), we'll be showcasing code you can use to reproduce key indicators included in the **PMA Longitudinal Brief** for each sample. In many cases, you'll find separate reports available in English and French, and for both national and sub-national summaries. For reference, here are the highest-level population summaries available in English for each sample where Phase 2 IPUMS PMA data is currently available:

  * [Burkina Faso](https://www.pmadata.org/sites/default/files/data_product_results/Burkina%20National_Phase%202_Panel_Results%20Brief_English_Final.pdf)
  * [DRC - Kinshasa](https://www.pmadata.org/sites/default/files/data_product_results/DRC%20Kinshasa_%20Phase%202%20Panel%20Results%20Brief_English_Final.pdf)
  * [DRC - Kongo Central](https://www.pmadata.org/sites/default/files/data_product_results/DRC%20Kongo%20Central_%20Phase%202%20Panel%20Results%20Brief_English_Final.pdf)
  * [Kenya](https://www.pmadata.org/sites/default/files/data_product_results/Kenya%20National_Phase%202_Panel%20Results%20Brief_Final.pdf)
  * [Nigeria - Kano](https://www.pmadata.org/sites/default/files/data_product_results/Nigeria%20KANO_Phase%202_Panel_Results%20Brief_Final.pdf)
  * [Nigeria - Lagos](https://www.pmadata.org/sites/default/files/data_product_results/Nigeria%20LAGOS_Phase%202_Panel_Results%20Brief_Final.pdf) 

Panel data in these reports is limited to the *de facto* population of women who completed the Female Questionnaire in both Phase 1 and Phase 2. This includes women who slept in the household during the night before the interview for the Household Questionnaire. The *de jure* population includes women who are usual household members, but who slept elsewhere that night. We'll remove *de jure* cases recorded in the variable [RESIDENT](https://pma.ipums.org/pma-action/variables/RESIDENT#codes_section). 

For example, returning to our "wide" data extract for Burkina Faso, you can see the number of women who slept in the household before the Household Questionnaire for each phase reported in `RESIDENT_1` and `RESIDENT_2`: 

<div class="layout-chunk" data-layout="l-body">


</div>


<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class='va'>dat</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> <span class='fu'>count</span><span class='op'>(</span><span class='va'>RESIDENT_1</span><span class='op'>)</span>
</code></pre></div>

```
# A tibble: 3 × 2
                                         RESIDENT_1     n
                                          <int+lbl> <int>
1 11 [Visitor, slept in hh last night]                106
2 21 [Usual member, did not sleep in hh last night]   174
3 22 [Usual member, slept in hh last night]          6510
```

<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class='va'>dat</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> <span class='fu'>count</span><span class='op'>(</span><span class='va'>RESIDENT_2</span><span class='op'>)</span>
</code></pre></div>

```
# A tibble: 5 × 2
                                                      RESIDENT_2     n
                                                       <int+lbl> <int>
1 11 [Visitor, slept in hh last night]                              74
2 21 [Usual member, did not sleep in hh last night]                230
3 22 [Usual member, slept in hh last night]                       5993
4 31 [Slept in hh last night, no response if usually lives in h…     1
5 NA                                                               492
```

</div>


<aside>
`NA` cases in `RESIDENT_2` represent women who were lost to follow-up in Phase 2. In Stata, these cases will be represented by blank values.
</aside>

The *de facto* population is represented in codes 11 and 22. We'll use `filter` to include only those cases. 

<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class='va'>dat_2</span> <span class='op'>&lt;-</span> <span class='va'>dat</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> 
  <span class='fu'><a href='http://gdfe.co/srvyr/reference/dplyr_single.html'>filter</a></span><span class='op'>(</span>
    <span class='va'>RESIDENT_1</span> <span class='op'>==</span> <span class='fl'>11</span> <span class='op'>|</span> <span class='va'>RESIDENT_1</span> <span class='op'>==</span> <span class='fl'>22</span>, 
    <span class='va'>RESIDENT_2</span> <span class='op'>==</span> <span class='fl'>11</span> <span class='op'>|</span> <span class='va'>RESIDENT_2</span> <span class='op'>==</span> <span class='fl'>22</span>
  <span class='op'>)</span> 

<span class='va'>dat_2</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> <span class='fu'>count</span><span class='op'>(</span><span class='va'>RESIDENT_1</span>, <span class='va'>RESIDENT_2</span><span class='op'>)</span>
</code></pre></div>

```
# A tibble: 4 × 3
                                 RESIDENT_1           RESIDENT_2     n
                                  <int+lbl>            <int+lbl> <int>
1 11 [Visitor, slept in hh last night]      11 [Visitor, slept …    56
2 11 [Visitor, slept in hh last night]      22 [Usual member, s…    39
3 22 [Usual member, slept in hh last night] 11 [Visitor, slept …    17
4 22 [Usual member, slept in hh last night] 22 [Usual member, s…  5855
```

</div>


Additionally, these reports only include women who completed (or partially completed) both Female Questionnaires. This information is reported in [RESULTFQ](https://pma.ipums.org/pma-action/variables/RESULTFQ#codes_section). In our "wide" extract, this information appears in `RESULTFQ_1` and `RESULTFQ_2`: if you select the "Female Respondents" option at checkout, only women who completed (or partially completed) the Phase 1 Female Questionnaire will be included in your extract. 

<div class="layout-chunk" data-layout="l-body">
<img src="images/cases.png" width="883" />

</div>


We'll further restrict our sample by selecting only cases where `RESULTFQ_2` shows that the woman also completed the Phase 2 questionnaire. Notice that, in addition to each of the value 1 through 10, there are several **top codes** for different types of non-response numbered 90 through 99. You'll see similar values repeated across all IPUMS PMA variables, except that they will be left-padded to match the maximum width of a particular variable (e.g. `9999` is used for [INTFQYEAR](https://pma.ipums.org/pma-action/variables/INTFQYEAR#codes_section), which represents a 4-digit year for the Female Interview). 

<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class='va'>dat</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> <span class='fu'>count</span><span class='op'>(</span><span class='va'>RESULTFQ_2</span><span class='op'>)</span>
</code></pre></div>

```
# A tibble: 11 × 2
                                       RESULTFQ_2     n
                                        <int+lbl> <int>
 1  1 [Completed]                                  5491
 2  2 [Not at home]                                  78
 3  3 [Postponed]                                    22
 4  4 [Refused]                                      66
 5  5 [Partly completed]                             12
 6  7 [Respondent moved]                             15
 7 10 [Incapacitated]                                19
 8 95 [Not interviewed (female questionnaire)]        4
 9 96 [Not interviewed (household questionnaire)]   192
10 99 [NIU (not in universe)]                       399
11 NA                                               492
```

</div>


Possible **topcodes** include: 

  * `95` Not interviewed (female questionnaire)
  * `96` Not interviewed (household questionnaire)
  * `97` Don't know
  * `98` No response or missing 
  * `99` NIU (not in universe)

The value `NA` in an IPUMS extract indicates that a particular variable is not provided for a selected sample. In a "wide" **Longitudinal** extract, it may also signify that a particular person was not included in the data from a particular phase. Here, an `NA` appearing in `RESULTFQ_2` indicates that a Female Respondent from Phase 1 was not found in Phase 2.

You can drop incomplete Phase 2 female responses as follows: 

<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class='va'>dat_3</span> <span class='op'>&lt;-</span> <span class='va'>dat</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> <span class='fu'><a href='http://gdfe.co/srvyr/reference/dplyr_single.html'>filter</a></span><span class='op'>(</span><span class='va'>RESULTFQ_2</span> <span class='op'>==</span> <span class='fl'>1</span><span class='op'>)</span> 

<span class='va'>dat_3</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> <span class='fu'>count</span><span class='op'>(</span><span class='va'>RESULTFQ_1</span>, <span class='va'>RESULTFQ_2</span><span class='op'>)</span>
</code></pre></div>

```
# A tibble: 2 × 3
            RESULTFQ_1    RESULTFQ_2     n
             <int+lbl>     <int+lbl> <int>
1 1 [Completed]        1 [Completed]  5487
2 5 [Partly completed] 1 [Completed]     4
```

</div>


Generally, we will combine both filtering steps together in a single function like so:

<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class='va'>dat</span> <span class='op'>&lt;-</span> <span class='va'>dat</span> <span class='op'><a href='http://gdfe.co/srvyr/reference/pipe.html'>%&gt;%</a></span> 
  <span class='fu'><a href='http://gdfe.co/srvyr/reference/dplyr_single.html'>filter</a></span><span class='op'>(</span>
    <span class='va'>RESIDENT_1</span> <span class='op'>==</span> <span class='fl'>11</span> <span class='op'>|</span> <span class='va'>RESIDENT_1</span> <span class='op'>==</span> <span class='fl'>22</span>, 
    <span class='va'>RESIDENT_2</span> <span class='op'>==</span> <span class='fl'>11</span> <span class='op'>|</span> <span class='va'>RESIDENT_2</span> <span class='op'>==</span> <span class='fl'>22</span>,
    <span class='va'>RESULTFQ_2</span> <span class='op'>==</span> <span class='fl'>1</span>
  <span class='op'>)</span> 
</code></pre></div>

</div>


In upcoming posts, we'll use the remaining cases to show how PMA generates key indicators for **contraceptive use status** and **family planning intentions and outcomes**. The summary report for each country includes measures disaggregated by demographic variables like:

  * [MARSTAT](https://pma.ipums.org/pma-action/variables/MARSTAT#codes_section) - marital status 
  * [EDUCATT](https://pma.ipums.org/pma-action/variables/EDUCATT#codes_section) and [EDUCATTGEN](https://pma.ipums.org/pma-action/variables/EDUCATTGEN#codes_section) - highest attended level of education^[Levels in `EDUCATT` may vary by country; `EDUCATTGEN` recodes country-specific levels in four general categories.] 
  * [AGE](https://pma.ipums.org/pma-action/variables/AGE#codes_section) - age^[Ages are frequently reported in five-year groups: 15-19, 20-24, 25-29, 30-34, 35-39, 40-44, and 45-49.] 
  * [WEALTHQ](https://pma.ipums.org/pma-action/variables/WEALTHQ#codes_section) and [WEALTHT](https://pma.ipums.org/pma-action/variables/WEALTHT#codes_section) - household wealth quintile or tertile^[Households are divided into quintiles/tertiles relative to the distribution of an asset [SCORE](https://pma.ipums.org/pma-action/variables/SCORE#description_section) weighted for all sampled households. For subnationally-representative samples (DRC and Nigeria), separate wealth distributions are calculated for each sampled region.]
  * [URBAN](https://pma.ipums.org/pma-action/variables/URBAN#codes_section) and [SUBNATIONAL](https://pma.ipums.org/pma-action/variables/SUBNATIONAL#codes_section) - geographic location^[`SUBNATIONAL` includes subnational regions for all sampled countries; country-specific variables are also available on the [household - geography](https://pma.ipums.org/pma-action/variables/group?id=hh_geo) page.]

We'll be releasing a new blog post in this series **every two weeks**, but you can also get regular updates from the [IPUMS Global Health Twitter](https://twitter.com/ipumsGH) page. Join us again on March 15 for a full rundown of both "wide" and "long" data extract options available from IPUMS PMA.  
```{.r .distill-force-highlighting-css}
```
