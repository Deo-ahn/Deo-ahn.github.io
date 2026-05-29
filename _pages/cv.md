---
layout: cv
permalink: /cv/
title: CV
nav: true
nav_order: 5
cv_pdf: /assets/pdf/cv.pdf
cv_format: rendercv # options: rendercv, jsonresume
description: Curriculum Vitae of Deokhyun Ahn.
toc:
  sidebar: left
---

<style>
  /* al_folio_cv ships .location with white-space:nowrap, which overflows
     the narrow date column into the right content column. Allow wrap
     and widen the date column on medium+ screens. */
  .cv .date-column .location {
    white-space: normal;
    word-break: keep-all;
    line-height: 1.3;
  }
  @media (min-width: 768px) {
    .cv .row > .date-column {
      flex: 0 0 22%;
      max-width: 22%;
      padding-right: 0.75rem;
    }
    .cv .row > .date-column + [class*="col-"] {
      flex: 0 0 78%;
      max-width: 78%;
    }
  }
</style>
