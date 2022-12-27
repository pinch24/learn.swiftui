//
//  CertificatesView.swift
//  SwiftUICombineAndData
//
//  Created by mk on 2022/12/27.
//

import SwiftUI

struct CertificatesView: View {
	@StateObject var certificateVM = CertificateViewModel()
	
    var body: some View {
		VStack {
			ForEach(certificateVM.certificates, id: \.id) { certificate in
				CertificateCard(certificate: certificate)
			}
		}
		.background(AccountBackground())
    }
}

struct CertificatesView_Previews: PreviewProvider {
    static var previews: some View {
        CertificatesView()
    }
}
