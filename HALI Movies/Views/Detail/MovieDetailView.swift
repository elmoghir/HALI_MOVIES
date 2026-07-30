//
//  MovieDetailView.swift
//  Hali Cinema
//

import SafariServices
import SwiftUI

struct MovieDetailView: View {
    @Environment(\.appEnvironment) private var environment
    let movieID: Int
    var namespace: Namespace.ID? = nil

    @State private var viewModel: MovieDetailViewModel?
    @State private var trailerURL: URL?
    @State private var selectedGalleryPath: String?
    @State private var scrollOffset: CGFloat = 0

    var body: some View {
        Group {
            if let viewModel {
                detailBody(viewModel)
            } else {
                ProgressView().tint(AppTheme.accent)
            }
        }
        .haliScreenBackground()
        .task {
            if viewModel == nil {
                let vm = MovieDetailViewModel(
                    movieID: movieID,
                    movieRepository: environment.movieRepository,
                    favoritesRepository: environment.favoritesRepository
                )
                viewModel = vm
                await vm.load()
            }
        }
        .sheet(item: Binding(
            get: { trailerURL.map(IdentifiableURL.init) },
            set: { trailerURL = $0?.url }
        )) { item in
            SafariView(url: item.url)
                .ignoresSafeArea()
        }
        .fullScreenCover(item: Binding(
            get: { selectedGalleryPath.map(IdentifiableString.init) },
            set: { selectedGalleryPath = $0?.value }
        )) { item in
            GalleryLightbox(
                url: environment.imageURLBuilder.url(path: item.value, size: "original")
            )
        }
    }

    @ViewBuilder
    private func detailBody(_ viewModel: MovieDetailViewModel) -> some View {
        switch viewModel.state {
        case .loading, .idle:
            VStack {
                Spacer()
                LottieLoadingView()
                Spacer()
            }
        case .failed(let message):
            ErrorStateView(
                title: String(localized: "Couldn't load movie"),
                message: message,
                onRetry: { Task { await viewModel.load() } }
            )
        case .empty:
            EmptyStateView(
                systemImage: "film",
                title: String(localized: "Movie not found"),
                message: String(localized: "This title may have been removed.")
            )
        case .loaded:
            if let detail = viewModel.detail {
                loadedContent(detail, viewModel: viewModel)
            }
        }
    }

    private func loadedContent(_ detail: MovieDetail, viewModel: MovieDetailViewModel) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                hero(detail, viewModel: viewModel)
                overviewSection(detail)
                metadataSection(detail)
                if let credits = detail.credits, !credits.cast.isEmpty {
                    castSection(credits)
                }
                if let trailer = detail.videos?.results.bestTrailer {
                    trailerSection(trailer)
                }
                if let images = detail.images, !(images.backdrops.isEmpty) {
                    gallerySection(images.backdrops)
                }
                if let reviews = detail.reviews?.results, !reviews.isEmpty {
                    reviewsSection(reviews)
                }
                if let collection = detail.belongsToCollection {
                    collectionSection(collection)
                }
                if let recs = detail.recommendations?.results, !recs.isEmpty {
                    recommendationLinks(title: String(localized: "Recommendations"), movies: recs)
                }
                if let similar = detail.similar?.results, !similar.isEmpty {
                    recommendationLinks(title: String(localized: "Similar Movies"), movies: similar)
                }
            }
            .padding(.bottom, 48)
        }
        .ignoresSafeArea(edges: .top)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                FavoriteButton(isFavorite: viewModel.isFavorite) {
                    viewModel.toggleFavorite()
                }
                Menu {
                    Button("Share", systemImage: "square.and.arrow.up") {
                        if let url = detail.asMovie.tmdbURL {
                            ShareHelper.shareItems([detail.displayTitle, url])
                        }
                    }
                    Button("Copy Link", systemImage: "link") {
                        if let url = detail.asMovie.tmdbURL {
                            ShareHelper.copyToPasteboard(url.absoluteString)
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(AppTheme.primaryText)
                }
            }
        }
    }

    private func hero(_ detail: MovieDetail, viewModel: MovieDetailViewModel) -> some View {
        ZStack(alignment: .bottomLeading) {
            PosterView(
                url: environment.imageURLBuilder.backdropURL(detail.backdropPath),
                cornerRadius: 0,
                contentMode: .fill
            )
            .frame(height: 420)
            .overlay {
                LinearGradient(
                    colors: [.clear, AppTheme.background.opacity(0.4), AppTheme.background],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .parallax(offset: scrollOffset)

            HStack(alignment: .bottom, spacing: 16) {
                Group {
                    if let namespace {
                        PosterView(url: environment.imageURLBuilder.posterURL(detail.posterPath, large: true))
                            .matchedGeometryEffect(id: "poster-\(detail.id)", in: namespace)
                    } else {
                        PosterView(url: environment.imageURLBuilder.posterURL(detail.posterPath, large: true))
                    }
                }
                .frame(width: 120, height: 180)
                .shadow(color: AppTheme.cardShadow, radius: 16, y: 8)

                VStack(alignment: .leading, spacing: 8) {
                    Text(detail.displayTitle)
                        .font(.title.weight(.bold))
                        .foregroundStyle(AppTheme.primaryText)
                        .lineLimit(3)
                    if let original = detail.originalTitle, original != detail.title {
                        Text(original)
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                    HStack(spacing: 8) {
                        RatingBadge(score: detail.voteAverage)
                        if let runtime = detail.formattedRuntime {
                            Text(runtime)
                                .font(.caption.weight(.medium))
                                .foregroundStyle(AppTheme.secondaryText)
                        }
                    }
                    if let genres = detail.genres {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(genres) { GenreChip(title: $0.name) }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, AppTheme.horizontalPadding)
            .padding(.bottom, 20)
        }
    }

    private func overviewSection(_ detail: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            if let tagline = detail.tagline, !tagline.isEmpty {
                Text(tagline)
                    .font(.headline)
                    .italic()
                    .foregroundStyle(AppTheme.accent)
            }
            if let overview = detail.overview, !overview.isEmpty {
                Text(String(localized: "Overview"))
                    .font(.title3.weight(.bold))
                    .foregroundStyle(AppTheme.primaryText)
                Text(overview)
                    .font(.body)
                    .foregroundStyle(AppTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            if let director = detail.credits?.director {
                Text("Directed by \(director.displayName)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.primaryText)
                    .padding(.top, 4)
            }
        }
        .padding(.horizontal, AppTheme.horizontalPadding)
    }

    private func metadataSection(_ detail: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: "Details"))
                .font(.title3.weight(.bold))
                .foregroundStyle(AppTheme.primaryText)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                meta("Status", detail.status)
                meta("Release", detail.releaseDate)
                meta("Language", detail.originalLanguage?.uppercased())
                meta("Votes", detail.voteCount.map(String.init))
                meta("Budget", detail.formattedBudget)
                meta("Revenue", detail.formattedRevenue)
            }

            if let companies = detail.productionCompanies?.compactMap(\.name), !companies.isEmpty {
                metaBlock("Production", companies.joined(separator: ", "))
            }
            if let countries = detail.productionCountries?.compactMap(\.name), !countries.isEmpty {
                metaBlock("Countries", countries.joined(separator: ", "))
            }
            if let homepage = detail.homepageURL {
                Link(destination: homepage) {
                    Label("Homepage", systemImage: "safari")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.accent)
                }
                .frame(minHeight: 44, alignment: .leading)
            }
        }
        .padding(.horizontal, AppTheme.horizontalPadding)
    }

    private func castSection(_ credits: Credits) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(String(localized: "Cast"))
                .font(.title3.weight(.bold))
                .foregroundStyle(AppTheme.primaryText)
                .padding(.horizontal, AppTheme.horizontalPadding)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 14) {
                    ForEach(credits.cast.prefix(20)) { member in
                        ActorCard(
                            member: member,
                            imageURL: environment.imageURLBuilder.profileURL(member.profilePath)
                        )
                    }
                }
                .padding(.horizontal, AppTheme.horizontalPadding)
            }
        }
    }

    private func trailerSection(_ trailer: Video) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: "Trailer"))
                .font(.title3.weight(.bold))
                .foregroundStyle(AppTheme.primaryText)
            TrailerButton {
                trailerURL = trailer.youtubeURL
            }
        }
        .padding(.horizontal, AppTheme.horizontalPadding)
    }

    private func gallerySection(_ images: [MovieImage]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(String(localized: "Gallery"))
                .font(.title3.weight(.bold))
                .foregroundStyle(AppTheme.primaryText)
                .padding(.horizontal, AppTheme.horizontalPadding)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(images.prefix(16)) { image in
                        Button {
                            selectedGalleryPath = image.filePath
                        } label: {
                            PosterView(
                                url: environment.imageURLBuilder.backdropURL(image.filePath, large: false),
                                cornerRadius: 16
                            )
                            .frame(width: 220, height: 124)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, AppTheme.horizontalPadding)
            }
        }
    }

    private func reviewsSection(_ reviews: [Review]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(String(localized: "Reviews"))
                .font(.title3.weight(.bold))
                .foregroundStyle(AppTheme.primaryText)

            ForEach(reviews.prefix(5)) { review in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(review.author ?? "Anonymous")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(AppTheme.primaryText)
                        Spacer()
                        if let rating = review.authorDetails?.rating {
                            RatingBadge(score: rating, compact: true)
                        }
                    }
                    Text(review.content ?? "")
                        .font(.footnote)
                        .foregroundStyle(AppTheme.secondaryText)
                        .lineLimit(6)
                }
                .padding(16)
                .haliCardStyle()
            }
        }
        .padding(.horizontal, AppTheme.horizontalPadding)
    }

    private func collectionSection(_ collection: MovieCollection) -> some View {
        HStack(spacing: 14) {
            PosterView(
                url: environment.imageURLBuilder.posterURL(collection.posterPath),
                cornerRadius: 16
            )
            .frame(width: 72, height: 108)
            VStack(alignment: .leading, spacing: 6) {
                Text(String(localized: "Collection"))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppTheme.accent)
                Text(collection.name ?? "")
                    .font(.headline)
                    .foregroundStyle(AppTheme.primaryText)
            }
            Spacer()
        }
        .padding(16)
        .haliCardStyle()
        .padding(.horizontal, AppTheme.horizontalPadding)
    }

    private func recommendationLinks(title: String, movies: [Movie]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.title3.weight(.bold))
                .foregroundStyle(AppTheme.primaryText)
                .padding(.horizontal, AppTheme.horizontalPadding)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 14) {
                    ForEach(movies) { movie in
                        NavigationLink(value: movie.id) {
                            MovieCard(
                                movie: movie,
                                posterURL: environment.imageURLBuilder.posterURL(movie.posterPath)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, AppTheme.horizontalPadding)
            }
        }
    }

    private func meta(_ title: String, _ value: String?) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(AppTheme.tertiaryText)
            Text(value?.isEmpty == false ? value! : "—")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.primaryText)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(AppTheme.cardBackground, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func metaBlock(_ title: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(AppTheme.tertiaryText)
            Text(value)
                .font(.subheadline)
                .foregroundStyle(AppTheme.primaryText)
        }
    }
}

// MARK: - Helpers

private struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
    init(url: URL) { self.url = url }
}

private struct IdentifiableString: Identifiable {
    let id = UUID()
    let value: String
    init(value: String) { self.value = value }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

struct GalleryLightbox: View {
    let url: URL?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()
            PosterView(url: url, cornerRadius: 0, contentMode: .fit)
                .ignoresSafeArea()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding()
            }
            .accessibilityLabel(Text("Close"))
        }
    }
}

private struct ParallaxModifier: ViewModifier {
    let offset: CGFloat

    func body(content: Content) -> some View {
        content
            .scaleEffect(1 + max(0, -offset) / 1000)
            .offset(y: offset > 0 ? offset * 0.3 : 0)
    }
}

extension View {
    func parallax(offset: CGFloat) -> some View {
        modifier(ParallaxModifier(offset: offset))
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(movieID: 550)
    }
    .environment(\.appEnvironment, .preview)
}
