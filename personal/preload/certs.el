;;; package --- Summary
;; Personal config for Emacs, integrating with Prelude.

;;; Commentary:
;; Adjust the certificates so that melpa doesn't fail, being "insecure".

;; Code:
;; Add certs for melpa
(require 'gnutls)
(add-to-list 'gnutls-trustfiles "/usr/local/etc/openssl/cert.pem")

(provide 'certs)
;;; certs.el ends here
